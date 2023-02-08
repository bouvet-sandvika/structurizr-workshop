workspace {

    model {
        oda = softwareSystem "Oda" "Hjemleveringstjeneste" "Oda" {
            leveringsTjeneste = container "Oda Leveringstjeneste" "Ansvar for orkestrering av leveranser fra Oda" "Java Webservice" "Oda Webservice" {
                lagerIntegrasjon = component "Lager Integrasjon" "komponent for integrasjon med lagertjeneste" "Java Client" "Client"
                varslingIntegrasjon = component "Varsling Integrasjon" "komponent for integrasjon med varslingstjeneste" "Java Client" "Client"
                postenIntegrasjon = component "Posten Integrasjon" "komponent for integrasjon med posten" "Java Client" "Client"
                frontendController = component "Frontend Controller" "Grensesnitt mot frontend" "gRPC Interface" {
                    this -> postenIntegrasjon "henter sporings- informasjon"
                    this -> lagerIntegrasjon "henter lagerbeholdning"
                }
                eksternController = component "Ekstern Controller" "Grensesnitt mot eksterne tjenester" "REST"
                adminController = component "Admin Controller" "Grensesnitt for administratorer" "REST" {
                    this -> lagerIntegrasjon "Henter og oppdaterer lagerbeholdning"
                }
            }

            lagerTjeneste = container "Oda Sentrallager" "Orkestrator for Odas Sentrallager" "Java Webservice" "Oda Webservice"  {
                lagerIntegrasjon -> this "Henter og oppdaterer lagerbeholdning"
            }
            varslingstjeneste = container "Oda Varslingstjeneste" "Orkestrator for Odas Sentrallager" "Java Webservice" "Oda Webservice" {
                varslingIntegrasjon -> this "Oppretter varslinger" "HTTP"
            }
            app = container "Oda App" "Mobilapplikasjon for Odas tjenester" "Xamarin app" "Mobile App" {
                this -> frontendController "Henter sporings- informasjon og lagerbeholdning" "gRPC"
            }
            odaWeb = container "Oda Web" "Webapplikasjon for Odas tjenester" "React" "Web Page" {
                this -> frontendController "Henter sporings- informasjon og lagerbeholdning" "gRPC"
            }
            lagerdatabase = container "Database" "Database for lagerbeholdning" "MySQL" "Database" {
                lagerTjeneste -> this "lagrer og oppdaterer lagerbeholdning" "SQL"
            }
        }

        nettbutikk = softwareSystem "Nettbutikk" {
            nettbutikkIntegrasjon = container "Integrasjonsløsning for nettbutikker" "Ekstern samlestjeneste for leveringstjenester til nettbutikker" "Integrasjon" "Ekstern" { 
                this -> eksternController "Sjekker om leveranse er mulig med oda og oppretter leveranser" "gRPC"
            }
            webshop = container "Webshop" "Nettbutikkens webtjeneste" "HTML" "Web Page" {
                this -> nettbutikkIntegrasjon "Henter tilgjengelige leveringsmetoder" "HTTP"
            }
        }

        
        posten = softwareSystem "Posten" "API for Postens tjenester" "Posten" {
            postenSporing = container "Postens sporingssystem" "Tjeneste for sporing av forsendelser via Posten" "Webservice" "Posten" {
                this -> eksternController "henter og oppdaterer sporings- informasjon" "HTTP"
                postenIntegrasjon -> this "henter og oppdaterer sporings- informasjon" "HTTP"
            }
        }

        kunde = person "Kunde" {
            this -> app "Bruker applikasjon"
            this -> odaWeb "Bruker nettside"
            varslingstjeneste -> this "Sender varslinger"
            this -> webshop "Handler varer"
        }
        admin = person "Admin" {
            this -> adminController "Henter lagerstatus og sporings- informasjon" "HTTP"
        }

        AD = softwareSystem "Påloggingstjeneste" {
            admin -> this "logger på"
            kunde -> this "logger på"
        }

        driver = person "Sjåfør" "Leverer varer fra Oda og samarbeidspartnere" {
            this -> eksternController "henter og oppdaterer leverings- informasjon" "HTTP"
        }
    }
    views {
        systemContext oda "Oda_context" {
            include *
        }
        container oda "Oda_container_all" {
            include "element.type==container"
            include "element.type==person"
            include "element.type==softwareSystem"
        }
        component leveringsTjeneste {
            include *
        }

        styles {
            element "Oda" {
                background #d1830f
            }
            element "Database" {
                shape Cylinder
                background #a19fa0
            }
            element "Mobile App" {
                shape MobileDevicePortrait
            }
            element "Web Page" {
                shape WebBrowser
            }
            element "Ekstern" {
                background #90139e
            }
            element "Oda Webservice" {
                background #d1830f
            }
            element "Posten" {
                background #9e1c13
            }
        }

        theme default 
    }

}