package com.planner.controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


@WebServlet("/temp.do")
public class TempSaveServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       

    public TempSaveServlet() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		
		request.setCharacterEncoding("UTF-8");
		

		String newDay = request.getParameter("newDay_"); //select > option에서 새로 선택한 날짜
		request.setAttribute("fromThisDay", newDay);
		
		String SavedDay = request.getParameter("dayPlan_"); //일정 > 스케줄 작성이 완료된 일자
		String savedPlan = request.getParameter("tempSave_"); //일정 > 스케줄 내용
		
		
		//데이터 잘 받아왔는지 확인하기
		System.out.println(SavedDay+"일차의 계획은 : "+savedPlan);
		System.out.println("그리고 새로운 날은 : "+newDay);
		
		//TODO 아직 DB는 만들지 않음. 테스트를 위한 저장 > plannermap에서 해당 정보를 토대로, 지난 저장 내역을 출력할 수 있는지
		request.setAttribute("savedDay", SavedDay); 
		request.setAttribute("savedPlan", savedPlan);
		
		request.getRequestDispatcher("/views/planner/plannermap.jsp").forward(request, response);
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}
