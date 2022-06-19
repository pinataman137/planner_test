package com.planner.model.vo;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class PlannerLog {

	String date;
	String id;
	String title;
	String latitude;
	String longitude;
	String memo;
	
}
