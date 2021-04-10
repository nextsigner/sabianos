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
        focus: true
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
            spacing: app.fs*0.25
            XSigno{
                id: xSigno
                numSign: app.numSign
                anchors.verticalCenter: parent.verticalCenter
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
        sequence: 'Ctrl+a'
        onActivated: {
            /*let string='joana 11.26 11.27 11.28'
            let m0=string.split(' ')
            let html=''
            let cantGrupos=1
            for(var i=1;i<m0.length;i++){
                let m1=m0[i].split('.')
                let s=parseInt(m1[0])
                let g=parseInt(m1[1])

                html+='<h2>Grupo '+parseInt(i+1)+'</h2>\n'
                html+=getHtmlData(s-1,g-1,0)
                html+=getHtmlData(s-1,g-1,1)
                html+=getHtmlData(s-1,g-1,2)
                html+='\n'
                cantGrupos++
            }
            setHtml(html, m0[0])*/
        }
    }
    Shortcut{
        sequence: 'Esc'
        onActivated: Qt.quit()
    }
    Shortcut{
        sequence: 'Ctrl+Down'
        onActivated: {
            if(app.numSign<11){
                app.numSign++
            }else{
                app.numSign=0
                app.currentInterpreter=0
            }
            loadData()
        }
    }
    Shortcut{
        sequence: 'Ctrl+Up'
        onActivated: {
            if(app.numSign>0){
                app.numSign--
            }else{
                app.numSign=11
                app.currentInterpreter=0
            }
            loadData()
        }
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
                app.currentInterpreter=2
                if(app.numDegree>0){
                    app.numDegree--
                }else{
                    app.numDegree=29
                    app.currentInterpreter=2
                    if(app.numSign>0){
                        app.numSign--
                    }else{
                        app.numSign=11
                    }
                }
            }
            loadData()
        }
    }
    Shortcut{
        sequence: 'Right'
        onActivated: {
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
        if(Qt.application.arguments.length===3){
            //Parametros esperados unik -folder=$PWD "laura 2.13.10:01 3.13.10:01 12.30.10:01"
            console.log('Creando html...')
            let stringMakeHtml=Qt.application.arguments[2]
            makeHtml(stringMakeHtml)
            Qt.quit()
            return
        }
        if(Qt.application.arguments.length===8){
            //Parametros esperados unik -folder=$PWD "nom" "fecha" "hora"  "2.13" "3.13" "12.30"
            //unik.speak('5 arguments')
            console.log('Creando html SAM...')
            console.log('Nombre:'+Qt.application.arguments[2])
            console.log('Fecha:'+Qt.application.arguments[3])
            console.log('Hora:'+Qt.application.arguments[4])
            console.log('Sol:'+Qt.application.arguments[5])
            console.log('Asc:'+Qt.application.arguments[6])
            console.log('Mc:'+Qt.application.arguments[7])
            //console.log('a7:'+Qt.application.arguments[8])
            //stringMakeHtml=Qt.application.arguments[6]
            let nom=Qt.application.arguments[2]
            let fecha=Qt.application.arguments[3]
            let hora=Qt.application.arguments[4]
            let sol=Qt.application.arguments[5]
            let asc=Qt.application.arguments[6]
            let mc=Qt.application.arguments[7]
            makeHtmlSAM(nom, fecha, hora, sol, asc, mc)
            Qt.quit()
            return
        }
        if(Qt.application.arguments.length===4){
            let ns=parseInt(Qt.application.arguments[2])-1
            let ng=parseInt(Qt.application.arguments[3])-1
            app.numSign=ns
            app.numDegree=ng
        }
        loadData()
    }
    function makeHtml(string){
        let m0=string.split(' ')
        let html=''
        let cantGrupos=1
        for(var i=1;i<m0.length;i++){
            let m1=m0[i].split('.')
            let s=parseInt(m1[0])
            let g=parseInt(m1[1])
            let h=m1[2]

            html+='<h2>Grupo '+parseInt(i)+'</h2>\n'
            html+='<h4>Hora de Nacimiento: '+h+'hs</h4>\n'
            html+=getHtmlData(s-1,g-1,0)
            html+=getHtmlData(s-1,g-1,1)
            html+=getHtmlData(s-1,g-1,2)
            html+='\n'
            cantGrupos++
        }
        setHtml(html, m0[0])
        let d=new Date(Date.now())
        let ms=d.getTime()
        let url='https://nextsigner.github.io/sabianos/'+m0[0]+'.html?r='+ms
        let sh='#!/bin/bash\n'
        sh+='cd /home/ns/nsp/uda/nextsigner.github.io\n'
        sh+='git add *\n'
        sh+='git commit -m "se sube el html '+m0[0]+' '+ms+'"\n'
        sh+='git push origin master\n'
        sh+='echo "Html subido!"\n'
        sh+='exit\n'
        unik.setFile('/tmp/'+ms+'.sh', sh)
        unik.ejecutarLineaDeComandoAparte('sh /tmp/'+ms+'.sh')
        console.log('Url: '+url+' script=/tmp/'+ms+'.sh')
    }

    //Sol Asc Mc
    function makeHtmlSAM(nom, fecha, hora, sol, asc, mc){
        //let m0=string.split(' ')
        let html=''
        html+='<h4>Fecha de Nacimiento: '+fecha+'</h4>\n'
        html+='<h4>Hora de Nacimiento: '+hora+'hs</h4>\n'

        let m1=sol.split('.')
        let s=parseInt(m1[0])
        let g=parseInt(m1[1])
        let h=m1[2]
        html+='<h2>Sol </h2>\n'
        html+=getHtmlData(s-1,g-1,0)
        html+=getHtmlData(s-1,g-1,1)
        html+=getHtmlData(s-1,g-1,2)
        html+='\n'

        m1=asc.split('.')
        s=parseInt(m1[0])
        g=parseInt(m1[1])
        h=m1[2]
        html+='<h2>Ascendente </h2>\n'
        html+=getHtmlData(s-1,g-1,0)
        html+=getHtmlData(s-1,g-1,1)
        html+=getHtmlData(s-1,g-1,2)
        html+='\n'

        m1=mc.split('.')
        s=parseInt(m1[0])
        g=parseInt(m1[1])
        h=m1[2]
        html+='<h2>Medio Cielo</h2>\n'
        html+=getHtmlData(s-1,g-1,0)
        html+=getHtmlData(s-1,g-1,1)
        html+=getHtmlData(s-1,g-1,2)
        html+='\n'

        setHtmlSAM(html, nom)
        let d=new Date(Date.now())
        let ms=d.getTime()
        let url='https://nextsigner.github.io/sabianos/'+nom+'.html?r='+ms
        let sh='#!/bin/bash\n'
        sh+='cd /home/ns/nsp/uda/nextsigner.github.io\n'
        sh+='git add *\n'
        sh+='git commit -m "se sube el html '+nom+' '+ms+'"\n'
        sh+='git push origin master\n'
        sh+='echo "Html subido!"\n'
        sh+='exit\n'
        unik.setFile('/tmp/'+ms+'.sh', sh)
        unik.ejecutarLineaDeComandoAparte('sh /tmp/'+ms+'.sh')
        console.log('Url: '+url+' script=/tmp/'+ms+'.sh')
    }
    function loadData(){
        let fileData=''+unik.getFile('360.html')
        let dataSign=fileData.split('---')
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
    function getHtmlData(s, g, item){
        let fileData=''+unik.getFile('360.html')
        let dataSign=fileData.split('---')
        let stringSplit=''
        if(g<=8){
            stringSplit='0'+parseInt(g+1)+'°:'
        }else{
            stringSplit=''+parseInt(g+1)+'°:'
        }
        let signData=''+dataSign[s+1]
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
        let mapHtmlDegree=htmlPrevio.split('<p ')
        let dataFinal=item===0?'<h3> Grado °'+parseInt(g + 1)+' de '+app.signos[s]+'</h3>\n':''
        dataFinal+='<p '+mapHtmlDegree[item + 1]
        if(apps.bgColor!=='#ffffff'){
            if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><strong><span style="color:')<0&&dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><span>strong style="color:')<0){
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:#ffffff"><strong>')
                dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><span ','<p class="entry-excerpt" style="text-align: left;color:#ffffff"><span ')
                dataFinal=dataFinal.replace('style="color: rgb(0, 0, 255);','style="color: rgb(255, 255, 255);')
            }else{
                if(dataFinal.indexOf('<p class="entry-excerpt" style="text-align: left;"><strong><span style="color: rgb(255, 0, 0);">'>=0)){
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:red"><strong>')
                }else{
                    dataFinal=dataFinal.replace('<p class="entry-excerpt" style="text-align: left;"><strong>','<p class="entry-excerpt" style="text-align: left;color:green"><strong>')
                }
            }
        }
        return dataFinal.replace(/style=\"text-align: justify;\"/g,'').replace(/&nbsp; /g, ' ')
    }
    function setHtml(html, nom){
        let htmlFinal='<DOCTYPE html>
<html>
<head>
    <title>'+nom+'</title>
</head>
    <body style="background-color:#ffffff;">
        <h1>Ajustando hora de nacimiento de '+nom+'</h1>
        <p>En esta página hay 3 grupos con 3 textos. Tenés que avisar cuál de todos estos grupos te parece que tiene más que ver con tu vida o tu forma de ser.</p>
        <p>Los textos que vas a leer a continuación, son como descripciones de imágenes que simbolizan una escena de algo que se puede presentar en tu vida de algn modo parecido o similar.</p>
        <p><b>Aviso: </b>Los textos en color rojo son algo negativos. Tantos los textos azules o rojos puede ser que aún no se hayan producido.</p>
        <br/>
        <h2>¿Cuál de los siguientes grupos de textos pensas que hablan de cosas más parecidas a tu vida o forma de ser?</h2>
        <br/>\n'
+html+
'<br />
         <br />
    </body>
</html>'
        unik.setFile('/home/ns/nsp/uda/nextsigner.github.io/sabianos/'+nom+'.html', htmlFinal)
    }
    function setHtmlSAM(html, nom){
        let htmlFinal='<DOCTYPE html>
<html>
<head>
    <title>'+nom+'</title>
</head>
    <body style="background-color:#ffffff;">
        <h1>Simbología de los Sabianos de  '+nom+'</h1>
        <p>Los textos que vas a leer a continuación, son como descripciones de imágenes que simbolizan una escena de algo que se puede presentar en tu vida de algn modo parecido o similar.</p>
        <p><b>Aviso: </b>Los textos en color rojo son algo negativos. Tantos los textos azules o rojos puede ser que aún no se hayan producido.</p>
        <br/>\n'
+html+
'<br />
         <br />
    </body>
</html>'
        unik.setFile('/home/ns/nsp/uda/nextsigner.github.io/sabianos/'+nom+'.html', htmlFinal)
    }
}
