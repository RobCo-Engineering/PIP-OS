/* JSONListModel - a QML ListModel with JSON and JSONPath support
 *
 * Copyright (c) 2012 Romain Pokrzywka (KDAB) (romain@kdab.com)
 * Licensed under the MIT licence (http://opensource.org/licenses/mit-license.php)
 */

import QtQuick
import "jsonpath-plus.js" as JSONPath

Item {
    property string source: ""
    property string json: ""
    property string query: ""
    property string sortKey: ""

    property ListModel model : ListModel { id: jsonModel }
    property alias count: jsonModel.count

    onSourceChanged: {
        var xhr = new XMLHttpRequest;
        xhr.open("GET", source);
        xhr.onreadystatechange = function() {
            if (xhr.readyState === XMLHttpRequest.DONE)
                json = xhr.responseText;
        }
        xhr.send();
    }

    onJsonChanged: updateJSONModel()
    onQueryChanged: updateJSONModel()

    function updateJSONModel() {
        jsonModel.clear();

        if ( json === "" )
            return;

        var objectArray = parseJSONString(json, query);

        // Optionally sort based on object key
        if (sortKey !== "") {
            objectArray.sort(function(a, b){
                return a[sortKey].localeCompare(b[sortKey]);
            })
        }

        for ( var key in objectArray ) {
            var jo = objectArray[key];

            // The Qt list model needs objects, if it's not an object then don't try to append it
            if (Object.prototype.toString.call(jo) === '[object Object]') {
                jsonModel.append( jo );
            }
        }
    }

    function parseJSONString(jsonString, jsonPathQuery) {
        var data = JSON.parse(jsonString);
        var objectArray = data;

        // If a query is specified use JSONPath to filter the data
        if ( jsonPathQuery !== "" ){
            objectArray = new JSONPath.modules.JSONPath({ json: objectArray, path: jsonPathQuery});
        }

        return objectArray;
    }
}
