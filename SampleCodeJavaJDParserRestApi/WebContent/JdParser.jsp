<%@page language="java"  session="true" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="Rchilli.*"%> 
<%@page import="java.io.File"%>
<%@page import="org.apache.commons.fileupload.util.Streams"%>
<%@page import="org.apache.commons.fileupload.servlet.ServletFileUpload"%>
<%@page import="org.apache.commons.fileupload.disk.DiskFileItemFactory"%>
<%@page import="org.apache.commons.fileupload.*"%>
<%@page import="java.io.FileInputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.InputStream"%>
<%@page import="java.io.InputStreamReader"%>
<%@page import="javax.naming.Context"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>

<%
	String jdTextArea="";
	String jdText="";
	String saveFile="";
	String strBase64 = "";
	String fileName ="";
    String contentType = request.getContentType();
	// set you logic to generate subuserid
    String subUserId="as per agreement";   
    
    CallJDApi callAPI = new CallJDApi();
	try 
	{
		if ((contentType != null) && (contentType.indexOf("multipart/form-data") >= 0)) 
		{
			ServletFileUpload upload = new ServletFileUpload();
			FileItemIterator iter = upload.getItemIterator(request);
			while (iter.hasNext()) 
			{
				FileItemStream item = iter.next();
				InputStream inputStream = item.openStream();
				if (item.isFormField()) 
				{
					String name = item.getFieldName();
					String value = Streams.asString(item.openStream());
					if (name.trim().equals("JDText")) 
					{
						jdText = value;
						jdTextArea = value;
					}
				}
				else 
				{
					try
					{
						fileName = item.getName();
						ServletContext context = pageContext.getServletContext();
						String root = context.getInitParameter("uploadPath");
						File path = new File(root+ "/upload/");
						
						if (!path.exists()) 
						{
							boolean status = path.mkdirs();
						}
						File uploadedFile = new File(path + "/"+ fileName);
						saveFile=uploadedFile.getAbsolutePath();
						try
						{
							if(uploadedFile.exists())
							{
						    	File file2= new File(saveFile.replace(fileName,"jdFile_"+ fileName));
						    	uploadedFile.renameTo(file2);
						    	saveFile=uploadedFile.getAbsolutePath();
							}
						}
						catch(Exception ex)
						{
						}
						
						FileOutputStream outputStream = new FileOutputStream(uploadedFile);
						byte[] buf = new byte[1024];
						int len;
						while ((len = inputStream.read(buf)) > 0) 
						{
							outputStream.write(buf,0, len);
						}
						inputStream.close();
						outputStream.close();
						ConvertToBase64 base64 = new ConvertToBase64();
						strBase64 = base64.Convert(saveFile);
					}
					catch (Exception ex) 
					{
						System.out.print(ex.getMessage());
						ex.printStackTrace();
					}
				}
			}
		}
	}
	catch (Exception ex) 
	{
		System.out.print(ex.getMessage());
	}
	  
	String output="";
  	if(jdText==null)
    {
   		jdText="";
   }
  
   
      if(!jdText.equals(""))
      {
   	   jdText= Base64.encodeBytes(jdText.getBytes());
       output=callAPI.ParseJDText(jdText, subUserId);
      }
      else if(!strBase64.equals(""))
      {
   	   output=callAPI.ParseJD(strBase64,fileName,subUserId);
      }
   
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>JdParser</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<style type="text/css">
body
{
	width:100%;
	height:100%;
	background:#312F30;
	
}


	#container
	{
		width:80%;
		height:90%;
		border:2px solid #9e9c9c;
		box-shadow:0 0 10px black;
		border-radius:0px;
		margin-left:9%;	
		background:white;	
	}
	#content
	{
		min-height:500px;
		background:white;
		padding:10px;
	}
	#top
	{
		border-bottom:2px solid #037291;
		box-shadow:0 0 10px black;
		border-radius:0px;
		padding:10px;
		background:#037291;
		color:white;
		text-shadow:0 0 5px white;
		
	}
	#result
	{
		border-bottom:2px solid #037291;
		box-shadow:0 0 10px black;
		border-radius:0px;
		padding:10px;
		background:#afd7e2;
		color:white;
		text-shadow:0 0 5px white;
		
	}
	#bottom
	{
		border-top:2px solid #037291;
		border-radius:0px;
		padding:10px;
		color:black;
		font-size:bolder;
	}
	input[type="password"],textarea
	{
		border:1px solid #9e9c9c;
		border-radius:0px;
		
	}
	
	input[type="password"]
	{
		height:25px;
	}
</style>
</head>
<body>
	<div class="container">
	  <div class="row">
	    <div class="col-lg-12 col-md-12 col-sm-12">
	    	<div id="top">
				<center><h2>RChilli JdParser<h2></center> 
		 	</div>
	    </div>
	  </div>
	  <div class="row">
	    <div class="col-lg-12 col-md-12 col-sm-12">
	    	<div id="content">
	    		<ul class="nav nav-tabs">
	    			<%
	    			if(!jdText.equals(""))
	    			{
	    				%>
	    				<li class=""><a href="#tab1" data-toggle="tab">Parse JD</a></li>
	    				<li class="active"><a href="#tab2" data-toggle="tab">Parse JD Text</a></li>
	    				<%
	    			}
	    			else
	    			{
	    				%>
	    				<li class="active"><a href="#tab1" data-toggle="tab">Parse JD</a></li>
	    				<li class=""><a href="#tab2" data-toggle="tab">Parse JD Text</a></li>
	    				<%
	    			}
	    			%>
                </ul>
	    		<br>
	    		<div class="tab-content">
	                <%
	    			if(!jdText.equals(""))
	    			{
	    				%>
	    				<div id="tab1" class="tab-pane fade in">
	    				<%	
	    			}
	    			else
	    			{
	    				%>
	    				<div id="tab1" class="tab-pane fade in active">
	    				<%
	    			}
	    			%>
	                	<form method="post" enctype="multipart/form-data">
		  					<div class="form-group">
		  						<div class="row">
			    					<div class="col-lg-2 col-md-2 col-sm-12">
		  								<label for="jdText">Upload JD</label>
		  							</div>
		  							<div class="col-lg-10 col-md-10 col-sm-12">
		  								<label class="btn btn-default">
										    <input type="file" name="fileUpload" hidden>
										</label>
		  							</div>
		  						</div>
		  					</div>
		  					<div class="form-group">
		  						<div class="row">
			    					<div class="col-lg-12 col-md-12 col-sm-12">
		  								<input type="submit" class="btn btn-default" value="ParseJD"/>
		  							</div>
		  						</div>
		  					</div>
		  				</form>
		  			</div>
		  			<%
		  			if(!jdText.equals(""))
	    			{
		  				%>
		  				<div id="tab2" class="tab-pane fade in active">
		  				<%
	    			}
		  			else
		  			{
		  				%>
		  				<div id="tab2" class="tab-pane fade in">
		  				<%
		  			}
		  			%>
		  				<form method="post" enctype="multipart/form-data">
		  					<div class="form-group">
		  						<div class="row">
			    					<div class="col-lg-2 col-md-2 col-sm-12">
		  								<label for="jdText">Enter JD Text</label>
		  							</div>
		  							<div class="col-lg-10 col-md-10 col-sm-12">
		  								<textarea class="form-control" rows="15" name="JDText"><%=jdTextArea %></textarea>
		  							</div>
		  						</div>
		  					</div>
		  					<div class="form-group">
		  						<div class="row">
			    					<div class="col-lg-12 col-md-12 col-sm-12">
		  								<input type="submit" class="btn btn-default" value="ParseJD"/>
		  							</div>
		  						</div>
		  					</div>
		  				</form>
		  			</div>
	  			</div>	
  			</div>
	    </div>
	  </div>
	  <div class="row">
	    <div class="col-lg-12 col-md-12 col-sm-12">
	    	<div id="result">
	    		<div class="row">
	    			<div class="col-lg-12 col-md-12 col-sm-12">
	    				<h3 style = "color : #187124;"><b>Result</b></h3>
	    			</div>
	    		</div>
	    		<div class="row">
	    			<div class="col-lg-3 col-md-3 col-sm-12">
	    				<textarea class="form-control" rows="20" name="JDXml" id="JDXml"><%=output %></textarea>
	    			</div>
	    			<div class="col-lg-9 col-md-9 col-sm-12">
	    				<ul class="nav nav-tabs">
		                    <li class="active"><a href="#mainFields" data-toggle="tab"><b>Main Fields</b></a></li>
		                    <li class=""><a href="#qualifications" data-toggle="tab"><b>Qualifications</b></a></li>
		                    <li class=""><a href="#certifications" data-toggle="tab"><b>Certifications</b></a></li>
		                    <li class=""><a href="#skills" data-toggle="tab"><b>Skills</b></a></li>
		                    <li class=""><a href="#otherFields" data-toggle="tab"><b>Other Fields</b></a></li>
		                </ul>
			    		<br>
			    		<div class="tab-content">
			                <div id="mainFields" class="tab-pane fade in active">
			                	<div class="row">
	    							<div class="col-lg-12 col-md-12 col-sm-12" style = "max-width : 95%; max-height : 250px; overflow-y:scroll;">
	    								<%
	    								try
	    								{
	    									%>
	    									<table width='100%'>
	    									<tr><td colspan='2' style = 'color : #910005;'><b>Main Fields</b></td></tr>
	    									<%
	    									if(callAPI.fileName != null)
			    							{
			    								%>
												<tr><td style = "color : #1A5276; width:20%;"><b>FileName</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.fileName %>"</td></tr>
												<%			    								
			    							}
	    									if(callAPI.parsingDate != null)
			    							{
			    								%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ParsingDate</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.parsingDate %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.organization != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>Organization</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.organization %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.staffingAgency != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>StaffingAgency</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.staffingAgency %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.aboutOrganization != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>AboutOrganization</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.aboutOrganization %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.jobCode != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>JobCode</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.jobCode %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.jobType != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>JobType</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.jobType %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.jobShift != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>JobShift</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.jobShift %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.isManagementJob != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>IsManagementJob</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.isManagementJob %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.industryType != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>IndustryType</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.industryType %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.excecutiveType != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ExcecutiveType</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.excecutiveType %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.postedOnDate != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>PostedOnDate</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.postedOnDate %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.closingDate != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ClosingDate</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.closingDate %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.contractDuration != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ContractDuration</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.contractDuration %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.hasContract != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>HasContract</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.hasContract %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.noticePeriod != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>NoticePeriod</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.noticePeriod %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.noOfOpenings != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>NoOfOpenings</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.noOfOpenings %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.relocation != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>Relocation</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.relocation %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.languages != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>Languages</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.languages %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.responsibilities != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>Responsibilities</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.responsibilities %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.contactEmail != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ContactEmail</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.contactEmail %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.contactPhone != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ContactPhone</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.contactPhone %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.contactPersonName != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>ContactPersonName</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.contactPersonName %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.webSite != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>WebSite</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.webSite %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.interviewType != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>InterviewType</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.interviewType %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.interviewDate != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>InterviewDate</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.interviewDate %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.interviewTime != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>InterviewTime</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.interviewTime %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.interviewLocation != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>InterviewLocation</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.interviewLocation %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.typeOfSource != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>TypeOfSource</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.typeOfSource %>"</td></tr>
												<%			    								
			    							}
			    							if(callAPI.jDHtmlData != null)
			    							{
												%>
												<tr><td style = "color : #1A5276; width:20%;"><b>JDHtmlData</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= callAPI.jDHtmlData %>"</td></tr>
												<%			    								
			    							}
	    									%>
	    									</table>
	    									<%
	    								}
	    								catch(Exception ex)
	    								{
	    									ex.printStackTrace();
	    								}
	    								%>							
	    							</div>
	    						</div>
			                </div>
			                <div id="qualifications" class="tab-pane fade in">
			                	<div class="row">
	    							<div class="col-lg-12 col-md-12 col-sm-12" style = "max-width : 95%; max-height : 250px; overflow-y:scroll;">
	    								<%
	    								try
	    								{
	    									ArrayList<HashMap<String, String>> qualifications = callAPI.qualification;
	    									if(qualifications.size() > 0)
	    									{
		    									%>
		    									<table width='100%'>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Qualifications</b></td></tr>
		    									<%
		    									for(HashMap<String, String> qualification : qualifications)
		    									{
		    										for(String qualificationKey : qualification.keySet())
		    										{
		    												%>
		    												<tr><td style = "color : #1A5276; width:20%;"><b>"<%= qualificationKey%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= qualification.get(qualificationKey) %>"</td></tr>
		    												<%
		    										}
		    									}
		    									%>
		    									</table>
		    									<%
	    									}
	    								}
	    								catch(Exception ex)
	    								{
	    									ex.printStackTrace();
	    								}
	    								%>							
	    							</div>
	    						</div>
			                </div>
			                <div id="certifications" class="tab-pane fade in">
			                	<div class="row">
	    							<div class="col-lg-12 col-md-12 col-sm-12" style = "max-width : 95%; max-height : 250px; overflow-y:scroll;">
	    								<%
	    								try
	    								{
	    									ArrayList<HashMap<String, String>> cerftifications = callAPI.certification;
	    									if(cerftifications.size() > 0)
	    									{
		    									%>
		    									<table width='100%'>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Certifications</b></td></tr>
		    									<%
		    									for(HashMap<String, String> certificateInfo : cerftifications)
		    									{
		    										for(String certificateKey : certificateInfo.keySet())
		    										{
		    											%>
		    											<tr><td style = "color : #1A5276; width:20%;"><b>"<%= certificateKey%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= certificateInfo.get(certificateKey) %>"</td></tr>
		    											<%
		    										}
		    									}
		    									%>
		    									</table>
		    									<%
	    									}
	    								}
	    								catch(Exception ex)
	    								{
	    									ex.printStackTrace();
	    								}
	    								%>							
	    							</div>
	    						</div>
			                </div>
			                <div id="skills" class="tab-pane fade in">
			                	<div class="row">
	    							<div class="col-lg-12 col-md-12 col-sm-12" style = "max-width : 95%; max-height : 250px; overflow-y:scroll;">
	    								<%
	    								try
	    								{
	    									ArrayList<HashMap<String, String>> skills = callAPI.skills;
	    									if(skills.size() > 0)
	    									{
		    									%>
		    									<table width='100%'>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Skills</b></td></tr>
		    									<%
		    									for(HashMap<String, String> skill : skills)
		    									{
		    										for(String skillKey : skill.keySet())
		    										{
		    												%>
		    												<tr><td style = "color : #1A5276; width:20%;"><b>"<%= skillKey%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= skill.get(skillKey) %>"</td></tr>
		    												<%
		    										}
		    									}
		    									%>
		    									</table>
		    									<%
	    									}
	    								}
	    								catch(Exception ex)
	    								{
	    									ex.printStackTrace();
	    								}
	    								%>							
	    							</div>
	    						</div>
			                </div>
			                <div id="otherFields" class="tab-pane fade in">
			                	<div class="row">
	    							<div class="col-lg-12 col-md-12 col-sm-12" style = "max-width : 95%; max-height : 250px; overflow-y:scroll;">
	    								<%
	    								try
	    								{
	    									HashMap<String, String> jobProfile = callAPI.jobProfile;
	    									HashMap<String, String> jobLocation = callAPI.jobLocation;
	    									HashMap<String, String> experienceRequired = callAPI.experienceRequired;
	    									HashMap<String, String> salaryOffered = callAPI.salaryOffered;
	    									HashMap<String, String> billRate = callAPI.billRate;
	    									HashMap<String, String> preferredDemographic = callAPI.preferredDemographic;
	    									ArrayList<String> domains = callAPI.domains;
	    									%>
	    									<table width='100%'>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Job Profile</b></td></tr>
		    									<%
		    									for(String key : jobProfile.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= jobProfile.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Job Location</b></td></tr>
		    									<%
		    									for(String key : jobLocation.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= jobLocation.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Experience Required</b></td></tr>
		    									<%
		    									for(String key : experienceRequired.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= experienceRequired.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Salary Offered</b></td></tr>
		    									<%
		    									for(String key : salaryOffered.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= salaryOffered.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Bill Rate</b></td></tr>
		    									<%
		    									for(String key : billRate.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= billRate.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Preferred Demographic</b></td></tr>
		    									<%
		    									for(String key : preferredDemographic.keySet())
		    									{
		    										%>
		    										<tr><td style = "color : #1A5276; width:20%;"><b>"<%= key%>"</b></td><td width = "10%"><b>:</b></td><td style = "color : #1E8449;"">"<%= preferredDemographic.get(key) %>"</td></tr>
		    										<%		
		    									}
		    									%>
		    									<tr><td colspan='2' style = 'color : #910005;'><hr></td></tr>
		    									<tr><td colspan='2' style = 'color : #910005;'><b>Domains</b></td></tr>
		    									<tr><td colspan='2' style = "color : #1E8449; width:20%;"><b><%= domains%></b></td></tr>
		    								</table>
	    									<%
	    								}
	    								catch(Exception ex)
	    								{
	    									ex.printStackTrace();
	    								}
	    								%>							
	    							</div>
	    						</div>
			                </div>
			            </div>
	    			</div>
	    		</div>
	    	</div>
	    </div>
	  </div>
	  <div class="row">
	    <div class="col-lg-12 col-md-12 col-sm-12">
	    	<div id="top">
				<center><h5>© 2017 Rchilli. All Rights Reserved.</h5></center> 
		 	</div>
	    </div>
	  </div>
	</div>
</body>
</html>