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
import com.planner.model.vo.PlannerLog;


@WebServlet("/planner/saveLog.do")
public class SaveLogServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
    private List<PlannerLog> list = new ArrayList();   

    public SaveLogServlet() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String jsonStr = request.getParameter("jsonData");
		
		Gson gson = new Gson();
		PlannerLog plan = gson.fromJson(jsonStr, PlannerLog.class);
		//System.out.println(plan);
		
		list.add(plan); //list에 추가하기

		for (PlannerLog plannerLog : list) {
			System.out.println(plannerLog);
		}
				
		System.out.println(list.size());
		
		
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}
	

}
