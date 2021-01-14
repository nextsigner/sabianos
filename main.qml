import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Window 2.0
import Qt.labs.settings 1.1

ApplicationWindow {
    id: app
    visible: true
    visibility: "Maximized"
    color: apps.bgColor
    property var signos: ['Aries', 'Tauro', 'Géminis', 'Cáncer', 'Leo', 'Virgo', 'Libra', 'Escorpio', 'Sagitario', 'Capricornio', 'Acuario', 'Piscis']
    property int numSign: 0
    property int numDegree: 0
    property int fs: width*0.025
    property int currentInterpreter: 0
    Settings{
        id: apps
        fileName: 'sabianos.cfg'
        property string bgColor: '#ffffff'
    }
    Item{
        id: xApp
        anchors.fill: parent
        MouseArea{
            anchors.fill: parent
            onDoubleClicked: {
                if(apps.bgColor==='#ffffff'){
                    apps.bgColor='#000000'
                }else{
                    apps.bgColor='#ffffff'
                }
                loadData()
            }
        }
        Text{
            id: data
            text: '<h1>Los Sabianos</h1>'
            font.pixelSize: app.fs
            width: xApp.width-app.fs*2
            wrapMode: Text.WordWrap
            //textFormat: Text.PlainText
            textFormat: Text.RichText
            anchors.centerIn: parent
        }
        Row{
            spacing: app.fs
            XSigno{
                id: xSigno
                numSign: app.numSign
            }
            Text {
                id: currentSign
                text: '<b>'+app.signos[app.numSign]+'</b>'//+' ci:'+app.currentInterpreter+' ad:'+app.numDegree+' cs:'+app.numSign
                font.pixelSize: app.fs*2
                //color: 'white'
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        Text {
            id: currentDegree
            property string sd: '?'
            text: '<b>'+sd+'</b>'//+' ci:'+app.currentInterpreter+' ad:'+app.numDegree+' cs:'+app.numSign
            font.pixelSize: app.fs*2
            //color: 'white'
            anchors.bottom: parent.bottom
            visible: false
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Down'
        onActivated: {
            if(app.numDegree<30){
                app.numDegree++
            }else{
                app.numDegree=0
                app.currentInterpreter=0
            }
            loadData()
        }
    }
    Shortcut{
        sequence: 'Up'
        onActivated: {
            if(app.numDegree>0){
                app.numDegree--
            }else{
                app.numDegree=30
                app.currentInterpreter=0
            }
            loadData()
        }
    }
    Shortcut{
        sequence: 'Left'
        onActivated: {
            if(app.currentInterpreter>0){
                app.currentInterpreter--
            }else{
                app.currentInterpreter=30
                if(app.numSign>0){
                    app.numSign--
                }else{
                    app.numSign=11
                }
            }
            loadData()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
            let aND=false
            if(app.currentInterpreter<2){
                app.currentInterpreter++
            }else{
                app.currentInterpreter=0
                if(app.numDegree<29){
                    app.numDegree++
                }else{
                    app.numDegree=0
                    app.currentInterpreter=0
                    if(app.numSign<11){
                        app.numSign++
                    }else{
                        app.numSign=0
                    }
                }
            }
            loadData()
        }
    }
    Component.onCompleted: {
        loadData()
    }
    function loadData(){
        let fileData=''+unik.getFile('360.html')
        let dataSign=fileData.split('---')
        //app.color='white'
        //console.log('-----------'+dataSign[app.numSign+1])
        //data.text='<h2  style="text-align: center;">'+dataSign[app.numSign+1]
        let stringSplit=''
        if(app.numDegree<=8){
            stringSplit='0'+parseInt(app.numDegree+1)+'°:'
        }else{
            stringSplit=''+parseInt(app.numDegree+1)+'°:'
        }

        let signData=''+dataSign[app.numSign+1]
        //console.log('\n\n\nAries---->>'+signData+'\n\n\n')
        let dataDegree=signData.split('<p ')
        let htmlPrevio=''
        let cp=0
        currentDegree.sd=stringSplit
        for(var i=0;i<dataDegree.length;i++){
            //console.log('\n\n\n\n'+stringSplit+'----------->>'+dataDegree[i])
            if(dataDegree[i].indexOf(stringSplit)>0){
                htmlPrevio+='<p '+dataDegree[i]
                cp++
                //console.log('\n\n----------->>'+htmlPrevio)
            }
        }
        console.log('Cantidad '+cp)
        //data.text=htmlPrevio
        //return
        //console.log('----------->>'+stringSplit)
        //console.log(htmlPrevio+'-----------'+dataDegree[app.numDegree])
        let mapHtmlDegree=htmlPrevio.split('<p ')
        let dataFinal='<p '+mapHtmlDegree[app.currentInterpreter + 1]

        if(apps.bgColor!=='#ffffff'){
            if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: justify;"><strong><span style="color:')<0&&dataFinal.indexOf('<p class="entry-excerpt" style="text-align: justify;"><span>strong style="color:')<0){
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><strong>','<p class="entry-excerpt" style="text-align: justify;color:#ffffff"><strong>')
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><span ','<p class="entry-excerpt" style="text-align: justify;color:#ffffff"><span ')
                dataFinal=dataFinal.replace('style="color: rgb(0, 0, 255);','style="color: rgb(255, 255, 255);')
            }else{
                if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: justify;"><strong><span style="color: rgb(255, 0, 0);">'>=0)){
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><strong>','<p class="entry-excerpt" style="text-align: justify;color:red"><strong>')
                }else{
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: justify;"><strong>','<p class="entry-excerpt" style="text-align: justify;color:green"><strong>')
                }
            }
        }
        data.text=dataFinal
    }
}
