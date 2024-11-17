import QtQuick
import "json-query.js" as JsonQuery

Item {
    property string query: "[*]"
    property var sortFunction
    property var data

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count


    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if (!data) return;

        var objectArray = JsonQuery.modules(query, { data: data }).value || [];

        // Optionally sort based on object key
        if (sortFunction) {
            objectArray.sort(sortFunction)
        }

        for ( var key in objectArray ) {
            var jo = objectArray[key];

            // The Qt list model needs objects, if it's not an object then don't try to append it
            if (Object.prototype.toString.call(jo) === '[object Object]') {
                jsonModel.append( jo );
            }
        }
    }
}
