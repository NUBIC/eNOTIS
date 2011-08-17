def technology_literacy
  section "TL" do

    label_1_2 "<b>1 = Not at all
      <br/> 2 = Not so well
      <br/> 3 = Okay
      <br/> 4 = Well
      <br/> 5 = Very well<br/></b>"

    grid "I can print a document." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can open a Web address directly." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can use search engines, such as Yahoo or Alta Vista." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end    
    grid "I can use \"save as\" when appropriate." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can use the \"reply\" and \"forward\" features for email." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can identify the host server from the Web address." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can read new mail messages." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end                
    grid "I can delete read email." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can send an email message." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end     
    grid "I can open an email program." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end 
    grid "I can open a previously saved file from any drive/directory." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end          
    grid "I can open a file attachment to an email." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end 
    grid "I can restart a computer." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end  
    grid "I can begin a new document." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can use a browser such an Nescape or Explorer to navigate the World Wide Web." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
    grid "I can switch a computer on." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end   
    grid "I can use \"back\" and \"forward\" to move between pages." do
      a "1"
      a "2"
      a "3"
      a "4"
      a "5"
      q "Not at all|Very well" , :pick => :one
    end
  end
end                        