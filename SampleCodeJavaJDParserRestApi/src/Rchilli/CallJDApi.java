package Rchilli;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

public class CallJDApi 
{

	String apiUrl = "";
	String userKey = "";
	String version = "";
	public boolean isError = false;
	public String ErrorCode = "";
	public String ErrorMsg = "";
	public String jdJson = "";
	
	
	public String fileName;
	public String parsingDate;
	public String organization;
	public String staffingAgency;
	public String aboutOrganization;
	public String jobCode; 
	public String jobType;
	public String jobShift;
	public String isManagementJob;
	public String industryType;
	public String excecutiveType;
	public String postedOnDate;
	public String closingDate;
	public String contractDuration;
	public String hasContract;
	public String noticePeriod;
	public String noOfOpenings;
	public String relocation;
	public String languages;
	public String responsibilities;
	public String duties;
	public String contactEmail;
	public String contactPhone;
	public String contactPersonName;
	public String webSite;
	public String interviewType;
	public String interviewDate;
	public String interviewTime;
	public String interviewLocation;
	public String typeOfSource;
	public String jobDescription;
	public String jDHtmlData;
	
	
	public HashMap<String, String> jobProfile = new HashMap<String, String>();
	public HashMap<String, String> jobLocation = new HashMap<String, String>();
	public HashMap<String, String> experienceRequired = new HashMap<String, String>();
	public HashMap<String, String> salaryOffered = new HashMap<String, String>();
	public HashMap<String, String> billRate = new HashMap<String, String>();
	public HashMap<String, String> preferredDemographic = new HashMap<String, String>();
	public ArrayList<String> domains = new ArrayList<String>();
	public ArrayList<HashMap<String, String>> skills = new ArrayList<HashMap<String, String>>();
	public ArrayList<HashMap<String, String>> qualification = new ArrayList<HashMap<String, String>>();
	public  ArrayList<HashMap<String, String>> certification = new ArrayList<HashMap<String, String>>();
	
	HashMap<String, String> skill;
	HashMap<String, String> qual;
	HashMap<String, String> certi;



	public CallJDApi() {
		 Context ctx;
		try {
			ctx = new InitialContext();
			apiUrl = (String) ctx.lookup("java:comp/env/ServiceUrl");;
			userKey= (String) ctx.lookup("java:comp/env/UserKey");
			version=(String) ctx.lookup("java:comp/env/Version");
		} catch (NamingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
	  
	  	
	}

	public String ParseJDText(String base64text, String subUserId) 
	{
		String input = "{\"base64text\":\"" + base64text + "\",\"userkey\":\"" + userKey + "\",\"version\":\"" + version
				+ "\",\"subuserid\":\"" + subUserId + "\"}";
		String response  = CallService(input,"ParseJDText");
		processOutput(response);
		return response;
	}
	public String ParseJD(String JDFileData,String FileName, String subUserId)
	{
		try 
		{
			String input = "{\"filedata\":\"" + JDFileData + "\",\"filename\":\""+FileName+"\",\"userkey\":\"" + userKey
					+ "\",\"version\":\"" + version + "\",\"subuserid\":\"" + subUserId + "\"}";
			String response = CallService(input,"ParseJD" );
			
			//read values from Json
			processOutput(response);
			
			return response;
		} catch (Exception ex) {
			return "";
		}
	}

	public String CallService(String input,String method) {
		StringBuilder sbOutput = new StringBuilder();
		try {

			URL url = new URL(apiUrl+method);
			HttpURLConnection conn = (HttpURLConnection) url.openConnection();
			conn.setDoOutput(true);
			conn.setRequestMethod("POST");
			conn.setRequestProperty("Content-Type", "application/json");
			OutputStream os =conn.getOutputStream();
			os.write(input.getBytes());
			os.flush();
			BufferedReader br =null;
			if(conn.getResponseCode()!=200)
			{
			
				br = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
			}
			else
			{
				br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
			}
			String output;
			while ((output = br.readLine()) != null) {
				sbOutput.append(output);
			}
			conn.disconnect();
		} catch (MalformedURLException e) {
			e.printStackTrace();
			isError = true;
			ErrorCode = "500";
			ErrorMsg = e.getLocalizedMessage();
		} catch (IOException e) {
			isError = true;
			ErrorCode = "500";
			ErrorMsg = e.getLocalizedMessage();
			e.printStackTrace();
		}

		return sbOutput.toString();
	}

	void processOutput(String jsonResponse) {
		JSONParser parser = new JSONParser();
		Object outputObject = null;
		try {
			outputObject = parser.parse(jsonResponse.toString());
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			isError = true;
			ErrorCode = "500";
			ErrorMsg = e.getLocalizedMessage();
			return;
		}
		JSONObject root = (JSONObject) outputObject;
		if (jsonResponse.contains("\"error\":")) {
			JSONObject obj = (JSONObject) root.get("error");
			isError = true;
			ErrorMsg = (String) obj.get("errormsg");
			ErrorCode = Long.toString((long) obj.get("errorcode"));
			return;
		}

		JSONObject obj = (JSONObject) root.get("JDParsedData");
		JSONObject jsonObj = (JSONObject) obj;
		for (Object key : jsonObj.keySet()) {
			// based on you key types
			String nodeName = (String) key;
			Object val = jsonObj.get(nodeName);
			try 
			{
				if (nodeName.equalsIgnoreCase("FileName")) 
				{
					if(val instanceof String)
			        {
						fileName = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ParsingDate")) 
				{
					if(val instanceof String)
			        {
						parsingDate = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("Organization")) 
				{
					if(val instanceof String)
			        {
						organization = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("StaffingAgency")) 
				{
					if(val instanceof String)
			        {
						staffingAgency = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("AboutOrganization")) 
				{
					if(val instanceof String)
			        {
						aboutOrganization = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JobCode")) 
				{
					if(val instanceof String)
			        {
						jobCode = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JobType")) 
				{
					if(val instanceof String)
			        {
						jobType = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JobShift")) 
				{
					if(val instanceof String)
			        {
						jobShift = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("IsManagementJob")) 
				{
					if(val instanceof String)
			        {
						isManagementJob = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("IndustryType")) 
				{
					if(val instanceof String)
			        {
						industryType = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ExcecutiveType")) 
				{
					if(val instanceof String)
			        {
						excecutiveType = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("PostedOnDate")) 
				{
					if(val instanceof String)
			        {
						postedOnDate = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ClosingDate")) 
				{
					if(val instanceof String)
			        {
						closingDate = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ContractDuration")) 
				{
					if(val instanceof String)
			        {
						contractDuration = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("HasContract")) 
				{
					if(val instanceof String)
			        {
						hasContract = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("NoticePeriod")) 
				{
					if(val instanceof String)
			        {
						noticePeriod = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("NoOfOpenings")) 
				{
					if(val instanceof String)
			        {
						noOfOpenings = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("Relocation")) 
				{
					if(val instanceof String)
			        {
						relocation = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("Languages")) 
				{
					if(val instanceof String)
			        {
						languages = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("Responsibilities")) 
				{
					if(val instanceof String)
			        {
						responsibilities = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ContactEmail")) 
				{
					if(val instanceof String)
			        {
						contactEmail = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ContactPhone")) 
				{
					if(val instanceof String)
			        {
						contactPhone = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("ContactPersonName")) 
				{
					if(val instanceof String)
			        {
						contactPersonName = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("WebSite")) 
				{
					if(val instanceof String)
			        {
						webSite = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("InterviewType")) 
				{
					if(val instanceof String)
			        {
						interviewType = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("InterviewDate")) 
				{
					if(val instanceof String)
			        {
						interviewDate = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("InterviewTime")) 
				{
					if(val instanceof String)
			        {
						interviewTime = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("InterviewLocation")) 
				{
					if(val instanceof String)
			        {
						interviewLocation = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("TypeOfSource")) 
				{
					if(val instanceof String)
			        {
						typeOfSource = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JobDescription")) 
				{
					if(val instanceof String)
			        {
						jobDescription = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JDHtmlData")) 
				{
					if(val instanceof String)
			        {
						jDHtmlData = (String) val;
			        }
				}
				else if (nodeName.equalsIgnoreCase("JobProfile")) 
				{
					JSONObject jobProObj = (JSONObject) val;
					jobProfile.put("title", (String) jobProObj.get("Title"));
					jobProfile.put("alias", (String) jobProObj.get("Alias"));
					jobProfile.put("relatedSkills", (String) jobProObj.get("RelatedSkills"));
				}
				else if (nodeName.equalsIgnoreCase("JobLocation")) 
				{
					JSONObject jobLocObj = (JSONObject) val;
					jobLocation.put("location", (String) jobLocObj.get("Location"));
					jobLocation.put("city", (String) jobLocObj.get("City"));
					jobLocation.put("state", (String) jobLocObj.get("State"));
					jobLocation.put("country", (String) jobLocObj.get("Country"));
					jobLocation.put("isoCountryCode", (String) jobLocObj.get("IsoCountryCode"));
					jobLocation.put("zipCode", (String) jobLocObj.get("ZipCode"));
				}
				else if (nodeName.equalsIgnoreCase("ExperienceRequired")) 
				{
					JSONObject expReqObj = (JSONObject) val;
					experienceRequired.put("minimumYearsExperience", (String) expReqObj.get("MinimumYearsExperience"));
					experienceRequired.put("maximumYearsExperience", (String) expReqObj.get("MaximumYearsExperience"));
				}
				else if (nodeName.equalsIgnoreCase("SalaryOffered")) 
				{
					JSONObject salOffObj = (JSONObject) val;
					salaryOffered.put("minAmount", (String) salOffObj.get("MinAmount"));
					salaryOffered.put("maxAmount", (String) salOffObj.get("MaxAmount"));
					salaryOffered.put("currency", (String) salOffObj.get("Currency"));
					salaryOffered.put("units", (String) salOffObj.get("Units"));
					salaryOffered.put("text", (String) salOffObj.get("Text"));
				}
				else if (nodeName.equalsIgnoreCase("BillRate")) 
				{
					JSONObject billRateObj = (JSONObject) val;
					billRate.put("minAmount", (String) billRateObj.get("MinAmount"));
					billRate.put("maxAmount", (String) billRateObj.get("MaxAmount"));
					billRate.put("currency", (String) billRateObj.get("Currency"));
					billRate.put("units", (String) billRateObj.get("Units"));
					billRate.put("text", (String) billRateObj.get("Text"));
				}
				else if (nodeName.equalsIgnoreCase("PreferredDemographic")) 
				{
					JSONObject prefDemoObj = (JSONObject) val;
					preferredDemographic.put("nationality", (String) prefDemoObj.get("Nationality"));
					preferredDemographic.put("visa", (String) prefDemoObj.get("Visa"));
					preferredDemographic.put("ageLimit", (String) prefDemoObj.get("AgeLimit"));
					preferredDemographic.put("others", (String) prefDemoObj.get("Others"));
				}
				else if (nodeName.equalsIgnoreCase("Domains")) 
				{
					JSONArray domainsObj = (JSONArray) val;
					Iterator i = domainsObj.iterator();
					while (i.hasNext()) 
				    {
						String domain = (String) i.next();
						domains.add(domain);
				    }
				}
				else if (nodeName.equalsIgnoreCase("Qualifications")) 
				{
					qual= new HashMap<String, String>();
		        	try
		        	{
			        	JSONObject preferredQualifications =(JSONObject)val;
			        	JSONArray preferredQualification =(JSONArray) preferredQualifications.get("Preferred");
			        	Iterator i = preferredQualification.iterator();
			        	qual.put("type", "perferred");
			        	String qualValues = "";
						while (i.hasNext()) 
					    {
							String qualValue = (String) i.next();
							qualValues = qualValues+qualValue+", ";
						}
						if(qualValues.contains(","))
						{
							qualValues = qualValues.substring(0,  qualValues.lastIndexOf(","));
						}
						qual.put(nodeName, qualValues);
						qualification.add(qual);
		        	}
		        	catch(Exception ex){}
		        	
		        	qual= new HashMap<String, String>();
		        	try
		        	{
			        	JSONObject requiredQualifications =(JSONObject)val;
			        	JSONArray requiredQualification =(JSONArray) requiredQualifications.get("Required");
			        	Iterator i = requiredQualification.iterator();
			        	qual.put("type", "required");
			        	String qualValues = "";
						while (i.hasNext()) 
					    {
							String qualValue = (String) i.next();
							qualValues = qualValues+qualValue+", ";
						}
						if(qualValues.contains(","))
						{
							qualValues = qualValues.substring(0,  qualValues.lastIndexOf(","));
						}
						qual.put(nodeName, qualValues);
						qualification.add(qual);
		        	}
		        	catch(Exception ex){}
				}
				else if (nodeName.equalsIgnoreCase("Certifications")) 
				{
					certi = new HashMap<String, String>();
					try
		        	{
			        	JSONObject preferredCertifications =(JSONObject)val;
			        	JSONArray preferredCertification =(JSONArray) preferredCertifications.get("Preferred");
			        	Iterator i = preferredCertification.iterator();
			        	certi.put("type", "perferred");
			        	String certiValues = "";
						while (i.hasNext()) 
					    {
							String certiValue = (String) i.next();
							certiValues = certiValues+certiValue+", ";
						}
						if(certiValues.contains(","))
						{
							certiValues = certiValues.substring(0,  certiValues.lastIndexOf(","));
						}
						certi.put(nodeName, certiValues);
						certification.add(certi);
		        	}
		        	catch(Exception ex){}
		        	
		        	qual= new HashMap<String, String>();
		        	try
		        	{
		        		JSONObject requiredCertifications =(JSONObject)val;
			        	JSONArray requiredCertification =(JSONArray) requiredCertifications.get("Required");
			        	Iterator i = requiredCertification.iterator();
			        	certi.put("type", "required");
			        	String certiValues = "";
						while (i.hasNext()) 
					    {
							String certiValue = (String) i.next();
							certiValues = certiValues+certiValue+", ";
						}
						if(certiValues.contains(","))
						{
							certiValues = certiValues.substring(0,  certiValues.lastIndexOf(","));
						}
						certi.put(nodeName, certiValues);
						certification.add(certi);
		        	}
		        	catch(Exception ex){}
				}
				else if (nodeName.equalsIgnoreCase("Skills")) 
				{
					skill= new HashMap<String, String>();
		        	try
		        	{
			        	JSONObject preferredSkills =(JSONObject)val;
			        	JSONArray preferredSkill =(JSONArray) preferredSkills.get("Preferred");
			        	Iterator i = preferredSkill.iterator();
			        	skill.put("type", "perferred");
			        	String skillValues = "";
						while (i.hasNext()) 
					    {
							String skillValue = (String) i.next();
							skillValues = skillValues+skillValue+", ";
						}
						if(skillValues.contains(","))
						{
							skillValues = skillValues.substring(0,  skillValues.lastIndexOf(","));
						}
						skill.put(nodeName, skillValues);
						skills.add(skill);
		        	}
		        	catch(Exception ex){}
		        	
		        	skill= new HashMap<String, String>();
		        	try
		        	{
			        	JSONObject requiredSkills =(JSONObject)val;
			        	JSONArray requiredSkill =(JSONArray) requiredSkills.get("Required");
			        	Iterator i = requiredSkill.iterator();
			        	skill.put("type", "required");
			        	String skillValues = "";
						while (i.hasNext()) 
					    {
							String skillValue = (String) i.next();
							skillValues = skillValues+skillValue+", ";
						}
						if(skillValues.contains(","))
						{
							skillValues = skillValues.substring(0,  skillValues.lastIndexOf(","));
						}
						skill.put(nodeName, skillValues);
						skills.add(skill);
		        	}
		        	catch(Exception ex){}
				}
			}
			catch (Exception ex) 
			{
				ex.printStackTrace();
			}
		}
	}
}
