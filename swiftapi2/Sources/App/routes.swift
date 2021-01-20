import Vapor
import SwiftCSV
import wkhtmltopdf

func routes(_ app: Application) throws {
    app.get { req in
        return "It works!"
    }
    
    app.on(.POST, "", body: .collect(maxSize: 20971520)) {
        req -> EventLoopFuture<Response> in
        let keys = "data;hora;ano;;titulo_eleicao;estado;;cod_cidade;cidade;;;nro_candidato;;;nome_candidato;cargo_disputado;;;;;;resultado;nro_partido_politico;sigla_partido_politico;nome_partido_politico;;coligacao;;;\n"
        guard let file = req.body.string,
              let csv = try? CSV(string: "\(keys)\(file)", delimiter: ";") else {
            return req.eventLoop.makeFailedFuture(NSError(domain: "lpp", code: 0, userInfo: nil))
        }
        
        let filteredList = csv.namedRows.filter { (item) -> Bool in
            return item["cod_cidade"] == "93734" && item["cargo_disputado"] == "DEPUTADO ESTADUAL" && item["resultado"] == "ELEITO"
        }
        let filteredListNoRepeated = Set(filteredList)
        var pageHtml = "<h1>Deputados Estaduais eleitos por Goiânia</h1><br><p>Nro          -     Nome Candidato       -    Partido<br>"
        for item in filteredListNoRepeated {
            pageHtml.append("\(item["nro_candidato"] ?? "")      -     \(item["nome_candidato"] ?? "")     -      \(item["sigla_partido_politico"] ?? "")<br>")
        }
        pageHtml.append("</p>")
        
        return req.eventLoop.makeSucceededFuture(Response(
            status: .ok,
            headers: HTTPHeaders([("Content-Type", "text/html")]),
            body: .init(data: pageHtml.data(using: .utf8)!)
        ))
    }
    
}
