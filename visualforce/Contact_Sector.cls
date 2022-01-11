<apex:page standardController="Contact" extensions="ContactSectorController">
  <apex:sectionHeader title="Contact" subtitle="{!contact.name}"/>
  <apex:form >
      <apex:pageBlock >
		<apex:pageBlockButtons >
		    <apex:commandButton action="{!step2}" value="Go to Sub Sectors"/>
		    <apex:commandButton action="{!cancel}" value="Cancel"/>
		</apex:pageBlockButtons>
		<apex:pageMessages />

		<apex:pageBlockSection title="Sectors" collapsible="false" showHeader="true" columns="1">           	
			<apex:pageBlockTable value="{!sectors}" var="s">
				<apex:column width="25px">
					<apex:inputCheckbox value="{!s.checked}"/>
				</apex:column>                               	
				<apex:column value="{!s.sector.Name}" headerValue="Sector"/>                                          	
			</apex:pageBlockTable>       	
		</apex:pageBlockSection>
		
      </apex:pageBlock>
  	
  </apex:form>
</apex:page>
