using HTTP
using EzXML


Version = "Julia API/0.1"
Type    = "text/xml"
url     = "https://sadermethod.org/api/1.1/api.php"


function SaderGCI_GetLeverList( UserName, Password )

    payload =  """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <saderrequest>
        <username>""" * UserName * """</username>
        <password>""" * Password * """</password>
        <operation>LIST</operation>
    </saderrequest>"""

    headers = (("User-Agent", Version),("Content-Type", Type))

    r = HTTP.request("POST", url, headers, body = String(payload))

    doc = parsexml(r.body)
    ids = nodecontent.(findall("//cantilevers/cantilever/id/text()", doc))
    labels = nodecontent.(findall("//cantilevers/cantilever/label/text()", doc))
    for x in eachindex(ids)
        println(labels[x], " (", replace(ids[x], "data_" => ""), ")" ) 
    end

end


function SaderGCI_CalculateK( UserName, Password, LeverNumber, Frequency, QFactor )

    payload =  """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <saderrequest>
        <username>""" * UserName * """</username>
        <password>""" * Password * """</password>
        <operation>UPLOAD</operation>
        <cantilever>
            <id>data_""" * string(LeverNumber) * """</id>
            <frequency>""" * string(Frequency) * """</frequency>
            <quality>""" * string(QFactor) * """</quality>
        </cantilever>
    </saderrequest>"""

    headers = (("User-Agent", Version),("Content-Type", Type))

    r = HTTP.request("POST", url, headers, body = String(payload))

    doc = parsexml(r.body)

    status = nodecontent.(findall("//status/code/text()", doc))
    if occursin(status[1],"OK")
        println(doc)
        println()
        println("Sader GCI Spring Constant = " * nodecontent.(findall("//cantilever/k_sader/text()", doc))[1] * ", 95% C.I. Error = " * nodecontent.(findall("//cantilever/percent/text()", doc))[1] * "% from " * nodecontent.(findall("//cantilever/samples/text()", doc))[1] * " samples.")
    end

end


function SaderGCI_CalculateAndUploadK( UserName, Password, LeverNumber, Frequency, QFactor, SpringK )

    payload =  """<?xml version=\"1.0\" encoding=\"UTF-8\"?>
    <saderrequest>
        <username>""" * UserName * """</username>
        <password>""" * Password * """</password>
        <operation>UPLOAD</operation>
        <cantilever>
            <id>data_""" * string(LeverNumber) * """</id>
            <frequency>""" * string(Frequency) * """</frequency>
            <quality>""" * string(QFactor) * """</quality>
            <constant>""" * string(SpringK) * """</constant>
            <comment>""" * Version * """</comment>
        </cantilever>
    </saderrequest>"""

    headers = (("User-Agent", Version),("Content-Type", Type))

    r = HTTP.request("POST", url, headers, body = String(payload))

    doc = parsexml(r.body)

    status = nodecontent.(findall("//status/code/text()", doc))
    if occursin(status[1],"OK")
        println(doc)
        println()
        println("Sader GCI Spring Constant = " * nodecontent.(findall("//cantilever/k_sader/text()", doc))[1] * ", 95% C.I. Error = " * nodecontent.(findall("//cantilever/percent/text()", doc))[1] * "% from " * nodecontent.(findall("//cantilever/samples/text()", doc))[1] * " samples.")
    end

end