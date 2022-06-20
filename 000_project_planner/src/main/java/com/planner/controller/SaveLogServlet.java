package com.planner.controller;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gson.Gson;
import com.planner.model.service.PlannerService;
import com.planner.model.vo.PlannerLog;


@WebServlet("/planner/saveLog.do")
public class SaveLogServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    private List<PlannerLog> list = new ArrayList();   

    public SaveLogServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		
		//1. 플래너 정보 저장하기   ------------------------------------------------------------------------------
		
		
		
		
		
		//2. 플랜 작성 정보 저장하기 ------------------------------------------------------------------------------
		//플랜 작성 정보 불러오기 
		String jsonStr = request.getParameter("jsonData");		
		Gson gson = new Gson();
		PlannerLog plan = gson.fromJson(jsonStr, PlannerLog.class);
		//System.out.println(plan);
		
		list.add(plan); //list에 추가하기

		for (PlannerLog plannerLog : list) {

			System.out.println(plannerLog);
		}
				
		System.out.println(list.size());
		//-----------------------------------------------------------------------------------------------------
		
		/*
		 * for (PlannerLog p : list) {
		 * 
		 * int res = new PlannerService().insertPlan(p); if(res<=0) {
		 * System.out.println("문제가 발생했습니다."); break; }
		 * 
		 * }
		 */
		
		//DB에 플랜 저장 後, 플랜 저장 완료 페이지로 이동함
		//DB에서 리스트를 가져올지, localStorage를 다시 사용할지 고민 중
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	

}
