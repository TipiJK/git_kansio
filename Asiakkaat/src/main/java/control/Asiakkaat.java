package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.JSONObject;

import model.Asiakas;
import model.dao.Dao;

@WebServlet("/asiakkaat/*")
public class Asiakkaat extends HttpServlet {
	private static final long serialVersionUID = 1L;
           
    public Asiakkaat() {
        super();
        System.out.println("Asiakkaat.Asiakkaat()");
    }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doGet()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot, esim. /aalto			
		System.out.println("polku: "+pathInfo);				//tulostaa tietoa konsoliin
		String hakusana="";
		if(pathInfo!=null) {		//jos hakusana on tyhj‰ ja yritt‰‰ korvata sit‰, ohjelma kaatuu. Siksi ehto.
			hakusana = pathInfo.replace("/", ""); //poistaa kauttaviivan, j‰ljelle j‰‰ vain hakusana
		}		
		Dao dao = new Dao();
		ArrayList<Asiakas> asiakkaat = dao.listaaKaikki(hakusana);
		System.out.println(asiakkaat);		//tulostaa daolta saadun tiedon konsoliin
		String strJSON = new JSONObject().put("asiakkaat", asiakkaat).toString();	//muodostaa JSON stringin
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.println(strJSON);		//tulostaa tietoa selaimeen
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPost()");
		JSONObject jsonObj = new JsonStrToObj().convert(request); //Muutetaan kutsun mukana tuleva json-string json-objektiksi	(sijaitsee control/JsonStrToObj.java)
		Asiakas asiakas = new Asiakas();
		asiakas.setEtunimi(jsonObj.getString("etunimi"));		//nimien t‰ytyy olla samat kuin syˆtt‰v‰ss‰ lomakkeessa
		asiakas.setSukunimi(jsonObj.getString("sukunimi"));
		asiakas.setPuhelin(jsonObj.getString("puhelin"));
		asiakas.setSposti(jsonObj.getString("sposti"));
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.lisaaAsiakas(asiakas)){ //palauttaa true/false
			out.println("{\"response\":1}");  //lis‰‰minen onnistui palauttaa selaimelle {"response":1}
		}else{
			out.println("{\"response\":0}");  //lis‰‰minen ep‰onnistui {"response":0}
		}		
	}
	
	protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doPut()");		
	}
	
	protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("Asiakkaat.doDelete()");
		String pathInfo = request.getPathInfo();	//haetaan kutsun polkutiedot	
		System.out.println("polku: "+pathInfo);
		pathInfo = pathInfo.replace("/", "");
		int poistettavaAsiakas_id = Integer.parseInt(pathInfo);	
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		Dao dao = new Dao();			
		if(dao.poistaAsiakas(poistettavaAsiakas_id)){ //metodi palauttaa true/false
			out.println("{\"response\":1}");  //poistaminen onnistui {"response":1}
		}else{
			out.println("{\"response\":0}");  //poistaminen ep‰onnistui {"response":0}
		}	
	}

}
