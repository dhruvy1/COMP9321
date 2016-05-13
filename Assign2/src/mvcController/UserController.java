package mvcController;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mvcModel.CustomerDTO;
import mvcModel.DBStorageDTO;
import mvcModel.DerbyDAOImpl;
import mvcModel.HotelDTO;
import mvcModel.RoomDTO;

/**
 * Servlet implementation class HotelController
 */
@WebServlet(urlPatterns="/usercontroller", displayName="UserController")
public class UserController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	//cast type can be used to interact with db
	//see  model derb implementsation fro more details
	private DerbyDAOImpl cast;
	private DBStorageDTO database;
	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UserController() {
		//uses model derby initiator to create connection to database
		super();
		try {
			cast = new DerbyDAOImpl();
			database = new DBStorageDTO();
			System.out.println("Refreshed");
			ArrayList<HotelDTO> allHotels = cast.initHotels();
			allHotels = cast.initRooms(allHotels);
			database.addAllHotels(allHotels); //init all hotels from schema
			database.addAllCustomers(cast.initCustomers());

		} catch (SQLException e) {
			e.printStackTrace();
		}

	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		System.out.println("GET");
		processRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		System.out.println("POST");
		processRequest(request, response);
		// TODO Auto-generated method stub
	}

	//all control flow and interation between servlets and jsps can occur here
	private void processRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String nextPage = "";
		//String action = request.getParameter("action");
		String curr = (String) request.getSession().getAttribute("CurrUser");	
		//^check if anyone is currently logged on this session
		String username = request.getParameter("user");
		String password = request.getParameter("pass");
		nextPage="login.jsp";
		if( curr != null || username != null && password != null && checkValid(username,password)){
			nextPage="home.jsp";
			if(curr == null){
				request.getSession().setAttribute("CurrUser", username);
			}
		}
		RequestDispatcher rd = request.getRequestDispatcher("/"+nextPage);
		rd.forward(request, response);
	}
	public boolean checkValid(String username, String password){
		for(CustomerDTO c: database.getAllCustomers()){
			if(c.getUser_name().equals(username)){
				if(c.getPassword().equals(password)){
					return true;
				}
				return false;
			}
		}
		return false;
	}

}