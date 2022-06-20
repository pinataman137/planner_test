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

		//쿠키 사용 後
		//"days"를 유지하고 있어야 함. 화면이 전환될 때도 이가 기준이 되기 때문임
		//"쿠키"를 사용하려고 함. "쿠키"는 HttpSession에 저장되는 시점(=플래너 확정 시점)에 삭제할 것임
		String days = request.getParameter("days");
		Cookie forOption = new Cookie("forOption",days);
		forOption.setMaxAge(24*60*60); //하루 동안 유지함
		response.addCookie(forOption);
		
		//작성자 정의 "테마" 정보를 넘기고자 함
		String theme = request.getParameter("theme");
		Cookie forTheme = new Cookie("forTheme",theme);
		forTheme.setMaxAge(24*60*60);
		response.addCookie(forTheme);
		
		//작성자 정의 "제목" 정보를 넘기고자 함
		String title = request.getParameter("title");
		Cookie forTitle = new Cookie("forTitle",title);
		forTitle.setMaxAge(24*60*60);
		response.addCookie(forTitle);
		
		//작성자 정의 "주요 방문 지역" 정보를 넘기고자 함
		//1. 지역코드 > 대분류
		String area = request.getParameter("area");
		Cookie forArea = new Cookie("forArea",area);
		forArea.setMaxAge(24*60*60);
		response.addCookie(forArea);
		//2. 지역코드 > 소분류(시/군/구)
		String sigungu = request.getParameter("sigungu");
		Cookie forSigungu = new Cookie("forSigungu",sigungu);
		forSigungu.setMaxAge(24*60*60);
		response.addCookie(forSigungu);
		
		response.sendRedirect(request.getContextPath()+"/views/planner/plannerMain.jsp");
		
		//-----------------------------------------------------------------------------------

		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
