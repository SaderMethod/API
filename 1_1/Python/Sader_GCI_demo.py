import requests
import xml.etree.ElementTree as etree

Version = 'Python API/0.11'
Type = 'text/xml'
url = 'https://sadermethod.org/api/1.1/api.php'


def SaderGCI_GetLeverList( UserName, Password ):
    payload = '''<?xml version="1.0" encoding="UTF-8" ?>
    <saderrequest>
      <username>'''+UserName+'''</username>
      <password>'''+Password+'''</password>
      <operation>LIST</operation>
    </saderrequest>'''
    headers = {'user-agent': Version, 'Content-type': Type}
    r = requests.post(url, data=payload, headers=headers)
    doc = etree.fromstring(r.content)
    
    cantilever_ids = doc.findall('./cantilevers/cantilever/id')
    cantilever_labels = doc.findall('./cantilevers/cantilever/label')

    for a in range(len(cantilever_ids)):
        print (cantilever_labels[a].text,cantilever_ids[a].text.replace('data_','(')+')')

        
def SaderGCI_CalculateK( UserName, Password, LeverNumber, Frequency, QFactor ):
    payload = '''<?xml version="1.0" encoding="UTF-8" ?>
    <saderrequest>
        <username>'''+UserName+'''</username>
        <password>'''+Password+'''</password>
        <operation>UPLOAD</operation>
        <cantilever>
            <id>data_'''+str(LeverNumber)+'''</id>
            <frequency>'''+str(Frequency)+'''</frequency>
            <quality>'''+str(QFactor)+'''</quality>
        </cantilever>
    </saderrequest>'''
    headers = {'user-agent': Version, 'Content-type': Type}
    r = requests.post(url, data=payload, headers=headers)
    print (r.text)
    doc = etree.fromstring(r.content)
    if (doc.find('./status/code').text == 'OK'):
        print ("Sader GCI Spring Constant = "+doc.find('./cantilever/k_sader').text+', 95% C.I. Error = '+doc.find('./cantilever/percent').text+'% from '+doc.find('./cantilever/samples').text+' samples.')

        
def SaderGCI_CalculateAndUploadK( UserName, Password, LeverNumber, Frequency, QFactor, SpringK ):
    payload = '''<?xml version="1.0" encoding="UTF-8" ?>
    <saderrequest>
        <username>'''+UserName+'''</username>
        <password>'''+Password+'''</password>
        <operation>UPLOAD</operation>
        <cantilever>
            <id>data_'''+str(LeverNumber)+'''</id>
            <frequency>'''+str(Frequency)+'''</frequency>
            <quality>'''+str(QFactor)+'''</quality>
            <constant>'''+str(SpringK)+'''</constant>
            <comment>'''+Version+'''</comment>
        </cantilever>
    </saderrequest>'''
    headers = {'user-agent': Version, 'Content-type': Type}
    r = requests.post(url, data=payload, headers=headers)
    print (r.text)
    doc = etree.fromstring(r.content)
    if (doc.find('./status/code').text == 'OK'):
        print ("Sader GCI Spring Constant = "+doc.find('./cantilever/k_sader').text+', 95% C.I. Error = '+doc.find('./cantilever/percent').text+'% from '+doc.find('./cantilever/samples').text+' samples.')