package com.opsmx.Services;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.util.Properties;

import org.apache.commons.io.IOUtils;
import org.json.simple.JSONObject;
import org.json.simple.JSONValue;
import org.json.simple.parser.JSONParser;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.opsmx.util.PropertiesUtil;
@Service
public class SpinnakerdeployementService {
	 static Properties properties = PropertiesUtil.getInstance();
	 static String SCRIPT_PATH = (String)properties.getProperty("script.path");
	 static String currentUserDir = System.getProperty("user.dir");
	
 //API aim is to deploy spinnaker
 public ObjectNode firstRunScriptExecution(String spinnakerConfigData) throws IOException {
		    //This API developed by "karunakar reddy"
		    String error,response = null;
		    String a1,a2,a3,a4,a5,a6,a7,a8,a9;
		
		    //getting the json data from json string which has UI parameters.
		    JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
		    ObjectNode rootNode = nodeFactory.objectNode();

		    Object object = JSONValue.parse(spinnakerConfigData);
		    JSONObject jObject = (JSONObject) object;
		    
		    //setting up json values to string arguments to be able to give to script
		    a1 = (String) jObject.get("platForm");
		    a2 = (String) jObject.get("version");
		    a3 = (String) jObject.get("accessKey");
		    a4 = (String) jObject.get("secretAccessKey");
		    a5 = (String) jObject.get("size");
		    a6 = (String) jObject.get("path");
		    a7 = (String) jObject.get("nameSpace");
		    a8 = (String) jObject.get("dockerRegistryUsername");
		    a9 = (String) jObject.get("spinnakerV2Account");

	    try {
			//setting the arguments to script
			ProcessBuilder processBuilder = new ProcessBuilder(properties.getProperty("script.submit"), a1, a2, a3, a4, a5, a6,a7,a8,a9);
			Process process = processBuilder.start();
			//waiting until the script to complete its execution
			process.waitFor();

			//GETTING ERROR STREAM FROM SCRIPT IF ANY
			BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			
			StringBuffer errorSB = new StringBuffer();
			while ((error = bufferedReader.readLine()) != null) {
				errorSB.append(error);
			}
			//getting input stream from script 
			BufferedReader bufferedReader2 = new BufferedReader(new InputStreamReader(process.getInputStream()));
			StringBuffer responseJson = new StringBuffer();

			while ((response = bufferedReader2.readLine()) != null) {
			responseJson.append(response);
	        }
			// IF ANY ERRORS RETURNING FAILURE MESSAGE AND ERRORS WHILE DEPLOYING SPINNAKER
			if (errorSB.length() >0) {
				
			rootNode.put("status", "failure");
			rootNode.put("message", responseJson.toString()+errorSB);
			return rootNode;
			}
			// IF NO ERRORS FOUND RETURNING SUCCESS MESSAGE AND GETTING THE INPUT STREAM
			else {
			rootNode.put("status", "success");
			rootNode.put("message", responseJson.toString());
			}
		    }
	        catch (Exception e) 
	        {
			e.printStackTrace();
			rootNode.put("failure", " Path Exception Occured");
			return rootNode;
	        }
		    return rootNode;
	}
 

//API aim is to check the dependency check
public ObjectNode getdependencycheckDetails() throws IOException {
	      
	       JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
	       ObjectNode rootNode = nodeFactory.objectNode();
	       String inputString=null;
		   
		   //getting the json data from json string which has UI parameters.
	   try {
		   ProcessBuilder processBuilder = new ProcessBuilder("sudo","/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.dependencycheck"));
	       Process process = processBuilder.start();
	       process.waitFor();
	       
	       inputString = IOUtils.toString(process.getInputStream());
			
		   if (inputString.length() > 0) {
		   System.out.println("inputString=====>"+inputString);
		   rootNode.put("status", "failure");
		   rootNode.put("message",inputString);
		   return rootNode;
		   } 
		   // IF NO ERRORS FOUND RETURNING SUCCESS status				
		   } catch (Exception e) {
		   e.printStackTrace();
		   rootNode.put("status","failure");
		   rootNode.put("message","Path Exception Occured");
		   return rootNode;
		   }
	       rootNode.put("status","success");
	       return rootNode;
	}


public JSONObject platformCheck(String platformData) {
	       //This API developed by "karunakar reddy"
	       String inputString = null;
           String a1;
           JSONObject result = new JSONObject();
           //JsonNodeFactory nodeFactory = new JsonNodeFactory(true);
           //ObjectNode rootNode = nodeFactory.objectNode();
       
           Object object = JSONValue.parse(platformData);
	       JSONObject jObject = (JSONObject) object;
	    
	       //setting up json values to string arguments to be able to give to script
	       a1 = (String) jObject.get("platForm");
       
       try {
	       //setting the arguments to script
	       ProcessBuilder processBuilder = new ProcessBuilder("sudo","/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.platformCheck"),a1);
	       Process process = processBuilder.start();
	       //waiting until the script to complete its execution
    
	       process.waitFor();
	  
	       //GETTING input STREAM FROM SCRIPT IF ANY
	       inputString = IOUtils.toString(process.getInputStream());
	       System.out.println("outouy is==="+inputString);
	       // IF we are getting some output we consider it as failure
	       JSONParser parser = new JSONParser();
	       JSONObject jsonResponse = (JSONObject) parser.parse(inputString);	   
	       return jsonResponse;
	   
	       // IF NO ERRORS FOUND RETURNING SUCCESS MESSAGE.
	  
           }
           catch (Exception e) 
           {
	       e.printStackTrace();
	       //rootNode.put("failure", " Path Exception Occured");
	       return result;
           }
           //rootNode.put("status", "success");
	   
       }
public JSONObject deploySpinnaker(String spinakerConfigData1) {
	       //This API developed by "karunakar reddy"
	       String inputString = null;
           String a1,a2;
       
           System.out.println(spinakerConfigData1);
           JSONObject result = new JSONObject();
       
           Object object = JSONValue.parse(spinakerConfigData1);
           JSONObject jObject = (JSONObject) object;
           a1 = (String) jObject.get("nameSpace");
	       a2 = (String) jObject.get("version");
   try {
	       //setting the arguments to script
	       ProcessBuilder processBuilder = new ProcessBuilder("sudo","/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.step8haldeploy"),a1,a2);
	       Process process = processBuilder.start();
	       //waiting until the script to complete its execution
 
	       process.waitFor();
	  
	       //GETTING input STREAM FROM SCRIPT IF ANY
	       inputString = IOUtils.toString(process.getInputStream());
	       System.out.println("inputstring is==="+inputString);
	       JSONParser parser = new JSONParser();
	       JSONObject jsonResponse = (JSONObject) parser.parse(inputString);	   
	       return jsonResponse;
	   
           }
           catch (Exception e) 
           {
	       e.printStackTrace();
	       return result;
           }
       
}
           // Method to check execute namespaceCheck script and give response 
 public JSONObject nameSpaceCheck(String platformData) {
	   
	       String inputString = null;
	       String a1;
	       JSONObject result = new JSONObject();    
    
	       Object object = JSONValue.parse(platformData);
	       JSONObject jObject = (JSONObject) object;
	    
	       //setting up json values to string arguments to be able to give to script
	       a1 = (String) jObject.get("namespace");
    
       try {
	       //setting the arguments to script
	       ProcessBuilder processBuilder = new ProcessBuilder("sudo","/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.namespacecheck"),a1);
	       Process process = processBuilder.start();
	       //waiting until the script to complete its execution 
	       process.waitFor();
	  
	       //GETTING input STREAM FROM SCRIPT IF ANY
	       inputString = IOUtils.toString(process.getInputStream());
	       System.out.println("inputStream==="+inputString);
		   
	       JSONParser parser = new JSONParser();
	       JSONObject jsonResponse = (JSONObject) parser.parse(inputString);	   
	       return jsonResponse;
	   
	       }
	       catch (Exception e) 
	       {
	       e.printStackTrace();	   
	       return result;
	   }   
	   	   
    }
 public JSONObject minioPullEnviorment(String minioPullEnviormentData) {
	       //This API developed by "karunakar reddy"
	       String inputString = null;
	       String a1,a3,a4,a5,a6,a7,a8,a9;
	       JSONObject result = new JSONObject(); 

	       //getting the json data from json string which has UI parameters.
	   

	       Object object = JSONValue.parse(minioPullEnviormentData);
	       JSONObject jObject = (JSONObject) object;
	    
	       //setting up json values to string arguments to be able to give to script
	       a1 = (String) jObject.get("platForm");
	       //a2 = (String) jObject.get("version");
	       a3 = (String) jObject.get("accessKey");
	       a4 = (String) jObject.get("secretAccessKey");
	       a5 = (String) jObject.get("size");
	       a6 = (String) jObject.get("path");
	       a7 = (String) jObject.get("nameSpace");
	       a8 = (String) jObject.get("dockerRegistryUsername");
	       a9 = (String) jObject.get("spinnakerV2Account");
	       System.out.println(a1+a3+a4+a5+a6+a7+a8+a9);
       try {
	       //setting the arguments to script
	       ProcessBuilder processBuilder = new ProcessBuilder("sudo","/bin/sh",currentUserDir+SCRIPT_PATH+"/"+properties.getProperty("script.step567miniopullhalenv"),a1,a3,a4,a5,a6,a7,a8,a9);
	       Process process = processBuilder.start();
	       //waiting until the script to complete its execution 
	       process.waitFor();
	    	  
	       //GETTING input STREAM FROM SCRIPT IF ANY
	       inputString = IOUtils.toString(process.getInputStream());
	       System.out.println("inputStream==="+inputString);
	    		   
	       
	       JSONParser parser = new JSONParser();
	       JSONObject jsonResponse = (JSONObject) parser.parse(inputString);	   
	       return jsonResponse;
	       
	       }
	       catch (Exception e) 
	       {
	       e.printStackTrace();	   
	       return result;
	   }   
	       	   

	}
}
