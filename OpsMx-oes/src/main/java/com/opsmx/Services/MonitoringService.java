package com.opsmx.Services;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import org.apache.commons.io.IOUtils;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.opsmx.util.PropertiesUtil;

@Service
public class MonitoringService {
	 static Properties properties = PropertiesUtil.getInstance();
	 static String SCRIPT_PATH = (String)properties.getProperty("script.path");
	 static String currentUserDir = System.getProperty("user.dir");
	 
	//API aim is to get instance of the spinnaker with health staus and version
	 public String getInstance(String parameters) throws FileNotFoundException, IOException {
		        //This API developed by "karunakar reddy"
	   		   
	            String jsonstring,yamlString=null;
	            //getting the json data from json string which has UI parameters.
	            Object object = JSONValue.parse(parameters);
		 		JSONObject jObject = (JSONObject) object;
		 		String b1 =  (String) jObject.get("nameSpace");
			 
			try {
				//executing script responsible to give spinnaker instancess
				
				
				ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.getinstances"),b1,currentUserDir+SCRIPT_PATH);
				Process process = processBuilder.start();
				
				//waiting until the script to complete its execution
				process.waitFor();
				
				//setting yaml input from script to a yaml string
				yamlString = IOUtils.toString(process.getInputStream());
				System.out.println(yamlString);
				
				//trying to convert the yamlstring to jsonstring
				ObjectMapper yamlReader = new ObjectMapper(new YAMLFactory());
			    Object obj = yamlReader.readValue(yamlString, Object.class);
			    ObjectMapper jsonWriter = new ObjectMapper();
			    jsonstring = jsonWriter.writeValueAsString(obj);
			    System.out.println(jsonstring.toString());
			    
			    }
			    catch (Exception e) 
			    {
				e.printStackTrace();
				return "exception";
			    }
			    return jsonstring;
		}
	 //API aim is to get all the details of services 
	 public String spinnakarDetailsShellScript(String parameters) throws FileNotFoundException, IOException {
		       //This API developed by "karunakar reddy"
		       System.out.println(parameters);
			   String jsonstring,yamlString=null;
			   
			   //getting the json data from json string which has UI parameters.
			   Object object = JSONValue.parse(parameters);
			   JSONObject jObject = (JSONObject) object;
			   String b1 =  (String) jObject.get("nameSpace");
			   System.out.println(b1);
			  
		   try {
			   //executing script responsible to give spinnakerdetailsscript
			   ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.spinnakerdetails"),b1);
			   Process process = processBuilder.start();
					
			   //waiting until the script to complete its execution
		    try{
		       process.waitFor();
		       } 
		       catch (InterruptedException e) {
		       System.out.println(e.getMessage());
		       }	
		    
			   //setting yaml input from script to a yaml string
			   yamlString = IOUtils.toString(process.getInputStream());
			   ObjectMapper yamlReader = new ObjectMapper(new YAMLFactory());
			   Object obj = yamlReader.readValue(yamlString, Object.class);
			   ObjectMapper jsonWriter = new ObjectMapper();
				    
			   //trying to convert the yamlstring to jsonstring
			   jsonstring = jsonWriter.writeValueAsString(obj);
			   System.out.println(jsonstring.toString());
				    	
			   }catch (Exception e) {
			   e.printStackTrace();
			   return "exception";
			   }
			   return jsonstring;
			   }
	//API aim is to return Unhealthy check issues
	 public ObjectNode getHealthStatusCheckDetails(String parameters) throws IOException {
	 	       //This API developed by "karunakar reddy"
	 	       JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	           ObjectNode rootNode = nodeFactory.objectNode();

	 	       String logString = null;
	 	  
	 	      //getting the json data from json string which has UI parameters.
	 		   Object object = JSONValue.parse(parameters);
	 		   JSONObject jObject = (JSONObject) object;
	 		   String b1 =  (String) jObject.get("nameSpace");
	           
	        try{
	        	System.out.println("gethealthscriptabouttoexecute");
	 	       //executing script responsible to give unhealthy logs
	            ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.py.healthy"),b1);
	            Process process = processBuilder.start();
	        try{
	 	       //waiting until the script to complete its execution
	            process.waitFor();
	           } 
	           catch (InterruptedException e) {
	           System.out.println(e.getMessage());
	           }
	           //setting  output from script to a log string
	           logString = IOUtils.toString(process.getInputStream());

	           System.out.println(logString);
	           }
	           catch (IOException e) {
	           System.out.println(e.getMessage());
	           }
	           rootNode.put("logs",logString);
	 	      return rootNode;

	     }

}
