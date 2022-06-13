package com.planner.controller;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/plannermaker.do")
public class PlannerMakerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public PlannerMakerServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//int days = Integer.parseInt(request.getParameter("days"));
		//System.out.println(days);
		//request.setAttribute("days", days);
		//request.getRequestDispatcher("/views/planner/plannermap.jsp").forward(request, response);
		
		//쿠키 사용 後
		//"days"를 유지하고 있어야 함. 화면이 전환될 때도 이가 기준이 되기 때문임
		//"쿠키"를 사용하려고 함. "쿠키"는 HttpSession에 저장되는 시점(=플래너 확정 시점)에 삭제할 것임
		String days = request.getParameter("days");
		Cookie forOption = new Cookie("forOption",days);
		forOption.setMaxAge(24*60*60); //하루 동안 유지함
		response.addCookie(forOption);
		response.sendRedirect(request.getContextPath()+"/views/planner/plannerMain.jsp");
		
		//-----------------------------------------------------------------------------------
		//충돌 테스트
		String confictTest = "충돌~";
		//git 테스트
		String test = "pinataman branch에는 없지!";
		
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
