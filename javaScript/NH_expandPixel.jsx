//////////////////////////////////////////////////////////////////////////
//アクティブレイヤーがあるか否か調べる関数
//////////////////////////////////////////////////////////////////////////
function existActiveLayer() {
    var actLayer= activeDocument.activeLayer; // アクティブレイヤー
    var layName= actLayer.name; // レイヤー名を取得
    try{
    actLayer.name= layName; // 同名のレイヤー名を設定してみる
    //executeAction( charIDToTypeID('undo'), undefined, DialogModes.NO ); //undo
    return true;
    }catch( e ){
    return false;
    }
    }
    //////////////////////////////////////////////////////////////////////////
    //一つ上のレイヤを選択する関数
    //////////////////////////////////////////////////////////////////////////
    function selectLayerForward() {
    var desc = new ActionDescriptor();
    var ref = new ActionReference();
    ref.putEnumerated( charIDToTypeID( "Lyr " ), charIDToTypeID( "Ordn" ), charIDToTypeID( "Frwr" ) );
    desc.putReference( charIDToTypeID( "null" ), ref );
    desc.putBoolean( charIDToTypeID( "MkVs" ), false );
    executeAction( charIDToTypeID( "slct" ), desc, DialogModes.NO );
    }
    //////////////////////////////////////////////////////////////////////////
    //一つ下のレイヤを選択する関数
    //////////////////////////////////////////////////////////////////////////
    function selectLayerBelow() {
    var desc = new ActionDescriptor();
    var ref = new ActionReference();
    ref.putEnumerated( charIDToTypeID( "Lyr " ), charIDToTypeID( "Ordn" ), charIDToTypeID( "Bckw" ) );
    desc.putReference( charIDToTypeID( "null" ), ref );
    desc.putBoolean( charIDToTypeID( "MkVs" ), false );
    executeAction( charIDToTypeID( "slct" ), desc, DialogModes.NO );
    }
    //////////////////////////////////////////////////////////////////////////
    //下のレイヤーと結合
    //////////////////////////////////////////////////////////////////////////
    function margeLayer(){
    var idMarge= charIDToTypeID('Mrg2');
    var actDesc= new ActionDescriptor();
    executeAction( idMarge, actDesc, DialogModes.NO );
    }
    //////////////////////////////////////////////////////////////////////////
    //動作
    //////////////////////////////////////////////////////////////////////////
    if (existActiveLayer()) {//選択したレイヤが存在した場合通常の動作
    uDlg = new Window('dialog',  'サンプル');
    uDlg.bounds = [1250,850,1475,925];
    uDlg.margins= 20;
    uDlg.sText = uDlg.add("statictext",[10, 10, 180, 24], "拡張するピクセル数を指定してください");
    uDlg.eText = uDlg.add("edittext",[185, 10, 205, 24], "2");
    uDlg.okBtn = uDlg.add("button", [30, 40, 120, 60], "実行", { name:"ok"});
    uDlg.cancelBtn = uDlg.add("button",[120, 40, 210, 60], "キャンセル", { name:"cancel"});
    uDlg.okBtn.onClick= function(){
    //情報を取得
    var pix = uDlg.eText.text;
    //オリジナルを保存、複製の作成
    var targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate();
    selectLayerForward();
    for(i=0;i<pix;i++){
    //複製レイヤーを（+1、0）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('1px', '0px');
    selectLayerForward();
    //複製レイヤーを（+1、+1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('1px', '1px');
    selectLayerForward();
    //複製レイヤーを（0、+1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('0px', '1px');
    selectLayerForward();
    //複製レイヤーを（-1、+1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('-1px', '1px');
    selectLayerForward();
    //複製レイヤーを（-1、0）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('-1px', '0px');
    selectLayerForward();
    //複製レイヤーを（-1、-1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('-1px', '-1px');
    selectLayerForward();
    //複製レイヤーを（0、-1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('0px', '-1px');
    selectLayerForward();
    //複製レイヤーを（+1、-1）移動
    targetLayer = activeDocument.activeLayer;//現在選択レイヤ取得
    targetLayer.duplicate(targetLayer, ElementPlacement.PLACEAFTER);
    selectLayerBelow();
    copyLayer = activeDocument.activeLayer;
    copyLayer.translate('1px', '-1px');
    selectLayerForward();
    //8枚のレイヤーをマージする
    for(j=0;j<8;j++){
    margeLayer();
    }
    }
    //名前を変更する
    var newName = 'NH_pixボーダー拡張（' + pix + 'pix）';
    activeDocument.activeLayer.name = newName;
    var alertTex = pix + 'pix分の拡張処理が完了しました';
    alert(alertTex);
    uDlg.close();
    }
    uDlg.cancelBtn.onClick = function(){
    uDlg.close();
    }
    uDlg.show();
    } else {
        alert ('レイヤーが選択されていません');
    }