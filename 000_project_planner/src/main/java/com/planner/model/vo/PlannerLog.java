package com.planner.model.vo;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class PlannerLog {

	private String plannerNo;
	private String planCode;
	private String day;
	private String id;
	private String placeName;
	private String latitude;
	private String longitude;
	private String memo;
	
}
