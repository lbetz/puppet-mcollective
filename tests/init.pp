include mcollective::server
include mcollective::client

mcollective::client::user { 'lbetz':
  user  => 'root',
  group => 'root',
  home  => '/root',
  cert  => '-----BEGIN CERTIFICATE-----
MIIFTzCCAzegAwIBAgIBFjANBgkqhkiG9w0BAQsFADAqMSgwJgYDVQQDDB9QdXBw
ZXQgQ0E6IHJvdXRlci5wcmVmb3JrLmxvY2FsMB4XDTE0MTExNjE0MDQ1NVoXDTE5
MTExNjE0MDQ1NVowEDEOMAwGA1UEAwwFbGJldHowggIiMA0GCSqGSIb3DQEBAQUA
A4ICDwAwggIKAoICAQCXurpbYmQLukgJhQWySI8QOXWdG+X7Cg6JBVguwGi90pTy
IZNmD6ZsiCGtiPxNuDN/8DGdeyC/SA8ELFeFLEC4vSNC9e64tQ4xZH/kHMtrqTF1
DDevq5KDDz4VXz1gVp9xuccHZBIUS+PgXvaMN0G4UXIzAa+5sTFlwfwTYHcCqEw5
7s2PREOPirDlsjgwEcvVgZpfexgDYjMb2KglZpnvAXfX9Xy2OF1MnIoF01jgpNzW
doJnWyL70q6ibNPM+fP6emKsxZ6KAgiCiAAZWgdj1lN8NmkprZgymSMhYNQuvWv6
fDaoBbe8fKc9pUX5lUh7yfculHFFXpBoEJBl46RiO72IuQUlC7K2Yumwn4rYahMa
6Es7nGIiBO9i55etvHIC5H/2qzwLqsSXvOZkWSedS+IsEoml+OoE6pDDBe+ZpEvP
5oNiZ5bHZH/6w0VssJGCCWSLguJHRpl5J1W7wlixbWuvkF9zOf5UZQJ81M8u+j3K
GJnzQIAULP6CDqy5Hwx+Ukh00Ad6xeinzCmV2bFWkuqKzFsBFBt+sghmk/wXkfVj
D9jFiLL0MXYdNX92zylOULm/8BRh94domCfFWP+OvOyTXFYJm5TNkIMw0rd3dHeT
bmWsxZnKDJUfs5TdetGPYIvvRiOHMkROm4EHLYGOFMlMTYptvUIhU2NTtumKmwID
AQABo4GZMIGWMDUGCWCGSAGG+EIBDQQoUHVwcGV0IFJ1YnkvT3BlblNTTCBJbnRl
cm5hbCBDZXJ0aWZpY2F0ZTAOBgNVHQ8BAf8EBAMCBaAwIAYDVR0lAQH/BBYwFAYI
KwYBBQUHAwEGCCsGAQUFBwMCMAwGA1UdEwEB/wQCMAAwHQYDVR0OBBYEFOWzQ7C6
DhQjJ2knwrlipELFPEvuMA0GCSqGSIb3DQEBCwUAA4ICAQBPrHWLkKqb/pmMdeCw
BWmHnPDE3uSQaZ8T8NH1hPmRmNUuXNw2r0qAElPf9xzRJObNf6jUPE5pmniQGbtt
8WPr81VMDm3npAfkz5SmTbhs1Z/toKaOK+MUVkFq189fTv727PqBTUwkk0XbxTSF
vLjaOFdnBitRGPOZBt7NsFXV/0mNVKq4QihV1GKzYHANxLiodTDcbBLISq2gzgfV
SzOGkvahDPIKBDH3c1ugUuPYPhFYLcRCrVY24/1Be5U1NxLuavM/0TFRU4P3I+mz
W5tilpt1KrVqjLezoUEDwaNCRgyYZwjcmUl2UoVg7nQpsGJnpdnqBo7aB2b70TyJ
JRrYQwe7h0KBLi7HyzJzALRT+gWNs2FwBOH6Z8si0ULAbawsYuNAdxJkYiZldy0/
WWDP5rfsor61/OgBog3hnjfeRkvKa/LLqka8/IXc87io0EiNCy6Ufybkg2Nqde9G
0uBkAA5jkFfIxWjC1nMF/KIrryqegofV/MgNuSXZ4mq4oCmUqTMWtaKT5QObtNrr
eSA8udrGhaGN1XL9XEEbdCOy5hpp/zzuPMi4Vp4RwW8NNNqbBLFn2ojzxI2dHISL
OTPyUUnh+8izLeNoLzoJA7RAeR72dVy1fGnO+lKlOF76EZcmgnsWXfpIOV95cZdU
O8X+Gp5ag6TbgIsZwhK59Rruwg==
-----END CERTIFICATE-----',
  key => '-----BEGIN RSA PRIVATE KEY-----
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
-----END RSA PRIVATE KEY-----',

}
