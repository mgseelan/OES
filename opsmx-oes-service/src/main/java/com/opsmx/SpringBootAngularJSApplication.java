package com.opsmx;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.Properties;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import com.opsmx.util.PropertiesUtil;

@SpringBootApplication
public class SpringBootAngularJSApplication {

	public static void main(String[] args) throws IOException {
		System.setProperty("server.port", "8888");
		createInfrastructure();
		SpringApplication.run(SpringBootAngularJSApplication.class, args);
	}

	public static void createInfrastructure() throws IOException {

		boolean append = true;
		boolean autoFlush = true;
		String charset = "UTF-8";
		String currentUserDir = System.getProperty("user.dir");
		String strManyDirectories = "scripts" + File.separator + "opt";
		boolean success = (new File(strManyDirectories)).mkdirs();
		System.out.println("success:" + success);
		Properties properties = PropertiesUtil.getInstance();
		System.out.println("script file :" + currentUserDir);
		Iterator<String> keys = (Iterator<String>) properties.elements();
		while (keys.hasNext()) {

			String fileName = keys.next();
			if (!fileName.contains("script")) {
				String filePath = currentUserDir + properties.getProperty("script.path") + "/" + fileName;
				System.out.println("file path" + filePath);
				File file = new File(filePath);
				file.createNewFile();
				FileOutputStream fos = new FileOutputStream(file);
				OutputStreamWriter osw = new OutputStreamWriter(fos, charset);
				BufferedWriter bw = new BufferedWriter(osw);
				PrintWriter pw = new PrintWriter(bw, autoFlush);
				InputStream inputStream = SpringBootAngularJSApplication.class
						.getResourceAsStream("/config/" + fileName);
				BufferedReader in = new BufferedReader(new InputStreamReader(inputStream));
				String inputLine;
				while ((inputLine = in.readLine()) != null) {
					pw.write(inputLine + "\n");
				}
				in.close();
				pw.close();
			}
		}
	}
}


