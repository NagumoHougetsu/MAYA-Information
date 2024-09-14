var word = activeDocument.activeLayer.name.split("_");
var allLayer = [];
var num = 0;

GetAllLayer(app.activeDocument)

function GetAllLayer(doc) {
    var layLength = doc.layers.length;
    for (var i = 0; i < layLength; i++) {
       if(doc.layers[i].typename == 'ArtLayer'){
            layName = doc.layers[i];
            allLayer[num] = layName;
            num++;
        }else if (doc.layers[i].typename == 'LayerSet') {
            GetAllLayer(doc.layers[i]);
        }
    }
};

for(i=0; i<allLayer.length; i++){
    var temp = allLayer[i].name.split("_")
    if(temp[0]== word[0]){
        transferEffects(activeDocument.activeLayer, allLayer[i]);
    }
    
}

function transferEffects(layer1, layer2) {
    app.activeDocument.activeLayer = layer1;
    try {
        var id157 = charIDToTypeID("CpFX");
        executeAction(id157, undefined, DialogModes.ALL);
        app.activeDocument.activeLayer = layer2;
        var id158 = charIDToTypeID("PaFX");
        executeAction(id158, undefined, DialogModes.ALL);
    } catch (e) {
        app.activeDocument.activeLayer = layer2;
    }
};




