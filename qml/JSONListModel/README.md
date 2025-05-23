# JSONListModel

## Usage

```
JSONListModel{
    id: list
    query: "Inventory"
    sortFunction: function(a, b) { return a.localeCompare(b) }
}
```

### Querying

You can use the online tester tool here https://maxleiko.github.io/json-query-tester/

### Sorting

The `sortKey` will filter an array of result objects based on this object key, alphabetically.
