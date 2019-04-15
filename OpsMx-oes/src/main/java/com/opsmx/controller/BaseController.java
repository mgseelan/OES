package com.opsmx.controller;

import java.io.FileNotFoundException;
import java.io.IOException;
import org.json.simple.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.opsmx.Services.AllLogsServices;
import com.opsmx.Services.MonitoringService;
import com.opsmx.Services.SpinnakerdeployementService;
@CrossOrigin(origins = "*", allowedHeaders = "*")
@RestController
public class BaseController {
	@Autowired
	public SpinnakerdeployementService deployement;
	@Autowired
	public AllLogsServices logs;
	@Autowired
	public MonitoringService monitor;
	
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/platformCheck",method=RequestMethod.POST,headers="Accept=application/json")
	public JSONObject platformCheck(@RequestBody String platformData) throws IOException, InterruptedException {
		return deployement.platformCheck(platformData);
	}
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/nameSpaceCheck",method=RequestMethod.POST,headers="Accept=application/json")
	public JSONObject nameSpaceCheck(@RequestBody String namespaceData) throws IOException, InterruptedException {
		return deployement.nameSpaceCheck(namespaceData);
	}
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/minioPullEnviorment",method=RequestMethod.POST,headers="Accept=application/json")
	public JSONObject minioPullEnviorment(@RequestBody String minioPullEnviormentData) throws IOException, InterruptedException {
		return deployement.minioPullEnviorment(minioPullEnviormentData);
	}
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/deploySpinnaker",method=RequestMethod.POST,headers="Accept=application/json")
	public JSONObject deploySpinnaker(@RequestBody String spinakerConfigData1) throws IOException, InterruptedException {
		return deployement.deploySpinnaker(spinakerConfigData1);
	}
	
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/deploySpinnakerInstance",method=RequestMethod.POST,headers="Accept=application/json")
	public ObjectNode deploySpinnakerInstance(@RequestBody String spinnakerConfigData) throws IOException, InterruptedException {
		return deployement.firstRunScriptExecution(spinnakerConfigData);
	} 
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value ="/getDependencyCheck", method = RequestMethod.GET, headers = "Accept=application/json")
	public ObjectNode getdependencycheck() throws IOException {
		System.out.println("dependencycheck method in base controller");
		return deployement.getdependencycheckDetails();
	}
	
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/getSpinnakarInstances",method=RequestMethod.POST,headers = "Accept=application/json")
	public String getSpinnakarInstances(@RequestBody String parameters) throws FileNotFoundException, IOException {
		//System.out.println(parameters);
		return monitor.getInstance(parameters);		
	}
	@CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value="/getSpinnakerDetails",method=RequestMethod.POST,headers = "Accept=application/json")
	public String getSpinnakardetails(@RequestBody String parameters) throws FileNotFoundException, IOException {
		System.out.println(parameters);
		return monitor.spinnakarDetailsShellScript(parameters);		
	}
   
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value ="/getHealthStatusCheck", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getHealthStatusCheck(@RequestBody String parameters) throws IOException {
   		System.out.println("getHealthStatusCheck method in base controller");
   		return monitor.getHealthStatusCheckDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
	@RequestMapping(value = "/getFront50Logs", method = RequestMethod.POST, headers = "Accept=application/json")
	public ObjectNode getFront50Logs(@RequestBody String parameters) throws IOException {
		System.out.println("getfront50Logs method in base controller");
		return logs.getfront50LogsDetails(parameters);
	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getEchoLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getEchoLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getEchoLogs method in base controller");
   		return logs.getEchoLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getCloudDriverLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getCloudDriverLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getCloudDriverLogs method in base controller");
   		return logs.getCloudDriverLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getDeckLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getDeckLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getDeckLogs method in base controller");
   		return logs.getDeckLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getFiatLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getFiatLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getFiatLogs method in base controller");
   		return logs.getFiatLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getGateLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getGateLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getGateLogs method in base controller");
   		return logs.getGateLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getIgorLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getIgorLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getIgorLogs method in base controller");
   		return logs.getIgorLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getKayentaLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getKayantaLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getKayantaLogs method in base controller");
   		return logs.getKayantaLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getOrcaLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getOrcaLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getOrcaLogs method in base controller");
   		return logs.getOrcaLogsDetails(parameters);
   	}
    @CrossOrigin(origins = "*", allowedHeaders = "*")
   	@RequestMapping(value = "/getRoscoLogs", method = RequestMethod.POST, headers = "Accept=application/json")
   	public ObjectNode getRoscoLogs(@RequestBody String parameters) throws IOException {
   		System.out.println("getRoscoLogs method in base controller");
   		return logs.getRoscoLogsDetails(parameters);
   	}
    		
}
