package com.opsmx.Services;

import java.io.IOException;
import java.util.Properties;

import org.apache.commons.io.IOUtils;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.opsmx.util.PropertiesUtil;

@Service
public class AllLogsServices {
	 static Properties properties = PropertiesUtil.getInstance();
	 static String SCRIPT_PATH = (String)properties.getProperty("script.path");
	 static String currentUserDir = System.getProperty("user.dir");
	
	
	//API aim is to get logs of front50 service 
	public ObjectNode getfront50LogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
		      ObjectNode rootNode = nodeFactory.objectNode();
		      String logString = null;
		       
			  //getting the json data from json string which has UI parameters.
		      Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
		      
		   try{
			  //executing script responsible to give front50logs 
			  ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.front50logs"),b1);
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
	public ObjectNode getEchoLogsDetails(String parameters) throws IOException {
	          //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
		      ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	    
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	   
	       try{
	          //executing script responsible to give echo logs
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.echologs"),b1);
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
	public ObjectNode getDeckLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	         
	       try{
	          //executing script responsible to give deck logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.decklogs"),b1);
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
	public ObjectNode getFiatLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	       
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	          //setting property file to set path of scripts
	        
	       try{
	           //executing script responsible to give fiat logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.fiatlogs"),b1);
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
	public ObjectNode getGateLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	          
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	          //setting property file to set path of scripts
	         
	       try{
	          //executing script responsible to give gate logs
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.gatelogs"),b1);
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
	public ObjectNode getCloudDriverLogsDetails(String parameters) throws IOException {
	          //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	          
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");	      
	 		  //setting property file to set path of scripts
	         
	       try{
	          //executing script responsible to give clouddriver logs
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.clouddriverlogs"),b1);
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
	public ObjectNode getIgorLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	          
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	          //setting property file to set path of scripts
	         
	       try{
	          //executing script responsible to give igor logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.igorlogs"),b1);
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
	public ObjectNode getKayantaLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	      
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	         
	       try{
	          //executing script responsible to give kayenta logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.kayentalogs"),b1);
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
	public ObjectNode getOrcaLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	        
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");
	          //setting property file to set path of scripts
	       
	       try{
	          //executing script responsible to give orca logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.orcalogs"),b1);
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
	public ObjectNode getRoscoLogsDetails(String parameters) throws IOException {
		      //This API developed by "karunakar reddy"
		      JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	          ObjectNode rootNode = nodeFactory.objectNode();
	          String logString = null;
	       
	          //getting the json data from json string which has UI parameters.
	          Object object = JSONValue.parse(parameters);
	 		  JSONObject jObject = (JSONObject) object;
	 		  String b1 =  (String) jObject.get("nameSpace");	       
	 		  //setting property file to set path of scripts
	      
	       try{
	          //executing script responsible to give rosco logs 
	          ProcessBuilder processBuilder = new ProcessBuilder("/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.roscologs"),b1);
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
