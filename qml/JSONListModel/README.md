# JSONListModel

Original component is an adaptation of https://github.com/kromain/qml-utils there were some issues with it and the JSONPath implementation was switched out to use https://github.com/JSONPath-Plus/JSONPath .

The `jsonpath-plus` library was converted to be QML compliant using https://gitlab.com/bhdouglass/qml-browserify

## Usage

```
JSONListModel{
    id: list
    source: "file:///path/to/file.json"
    sortKey: "text"
    query: "$..author"
}
```

### Querying

JSONPath querying examples are as follows https://github.com/JSONPath-Plus/JSONPath?tab=readme-ov-file#syntax-through-examples

### Sorting

The `sortKey` will filter an array of result objects based on this object key, alphabetically.
