# Version 0.10
#
# Requires the HTTP and EzXML installed
#
# MIT License
#
# Copyright (c) 2020 John Sader and Jason Kilpatrick
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software. The name "Sader Method - Global
# Calibration Initiative" or the equivalent "Sader Method GCI" and its URL 
# "sadermethod.org" shall be listed prominently in the title of any future 
# realization/modification of this software and its rendering in any AFM software
# or other platform, as it does in the header of this software and its rendering. 
# Reference to this software by any third party software or platform shall include
# the name "Sader Method - Global Calibration Initiative" or the equivalent "Sader
# Method GCI" and its URL "sadermethod.org".
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

using HTTP
using EzXML


Version = "Julia API/0.10"
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