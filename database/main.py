# thanks to https://medium.com/@cbrannen/importing-data-into-firestore-using-python-dce2d6d3cd51
# run this file to populate the firestore database

from dateutil import parser
import random
from lorem_text import lorem
import pprint as pprint
import csv

import firebase_admin
from firebase_admin import credentials, firestore

cred = credentials.Certificate("./key.json")
app = firebase_admin.initialize_app(cred)

store = firestore.client()

prod_ids = []


def productsGenerateDescriptions():
    print("Generating random lorem descriptions for products.")
    doc_ref = store.collection("products").stream()

    for doc in doc_ref:
        d = doc.to_dict()
        d["description"] = lorem.paragraph()
        store.collection("products").document(doc.id).set(d)
        prod_ids.append(doc.id)
    print("Done!")


def ordersGenerateProductMaps():
    print("Generating random product maps (product and amount) for orders.")
    doc_ref = store.collection("orders").stream()

    for doc in doc_ref:
        d = doc.to_dict()
        random.shuffle(prod_ids)
        count = 0
        prods = {}
        r = random.randint(1, 6)
        for i in range(r):
            prods[prod_ids[i]] = random.randint(1, 21)
        for prod in prods:
            count += (
                store.collection("products").document(prod).get().to_dict()["price"]
                * prods[prod]
            )
        d["products_and_amounts"] = prods
        d["total"] = count
        store.collection("orders").document(doc.id).set(d)
    print("Done!")


def batch_data(iterable, n=1):
    l = len(iterable)
    for ndx in range(0, l, n):
        yield iterable[ndx : min(ndx + n, l)]


def write(file_path, collection_name):

    print(
        "Writing to firestore - file_path: " + file_path,
        "collection_name: " + collection_name,
    )

    data = []
    headers = []

    with open(file_path) as csv_file:
        csv_reader = csv.reader(csv_file, delimiter=",")
        line_count = 0
        for row in csv_reader:
            if line_count == 0:
                for header in row:
                    headers.append(header)
                line_count += 1
            else:
                obj = {}
                for idx, item in enumerate(row):
                    if collection_name == "products":
                        if idx == 3 or idx == 5 or idx == 6:
                            item = int(item)
                    elif collection_name == "orders":
                        if idx == 1:
                            item = int(item)
                        if idx == 2:
                            item = parser.parse(item)
                        if idx == 3:
                            item = True if item == "TRUE" else False
                        if idx == 5:
                            item = float(item)
                    obj[headers[idx]] = item
                data.append(obj)
                line_count += 1

        print(f"Processed {line_count} lines.")

        for batched_data in batch_data(data, 499):
            batch = store.batch()
            for data_item in batched_data:
                doc_ref = store.collection(collection_name).document()
                batch.set(doc_ref, data_item)
            batch.commit()

        print(f"Done adding docs for {collection_name}.")

        print("Updating IDs...")
        docs = store.collection(collection_name).stream()

        for doc in docs:
            doc_data = store.collection(collection_name).document(doc.id)
            doc_data.update({"id": doc.id})

        print(f"Done with {collection_name}.\n")


automated = True

collections = ["products", "orders"]

if automated:

    for collection in collections:
        file_path = "./" + collection + ".csv"
        collection_name = collection

        write(file_path, collection_name)
else:

    file_path = "./" + input("input csv file name: ") + ".csv"
    collection_name = input("input collection name: ")

    write(file_path, collection_name)

productsGenerateDescriptions()
ordersGenerateProductMaps()