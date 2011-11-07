def self_reported_habit_strength_formation
  section "HS" do
    # label_1 "Self-Reported Habit Strength Formation (For eating fewer calories & physical activity)<br/>"

    grid "Eating fewer calories is something....." do
      a "1 = Fully Disagree"
      a "2 = Quite Disagree"
      a "3 = Somewhat Disagree"
      a "4 = Neither Agree Nor Disagree"
      a "5 = Somewhat Agree"
      a "6 = Quite Agree"
      a "7 = Fully Agree"
      q "I do frequently" , :pick => :one
      q "I do automatically.", :pick => :one
      q "I do without having to consciously remember.", :pick => :one
      q "That makes me feel weird if I do not do it.", :pick => :one
      q "I do without thinking.", :pick => :one
      q "That would require effort NOT to do it.", :pick => :one
      q "That belongs to my (daily, weekly, monthly) routine.", :pick => :one
      q "I start doing before I realize I'm doing it.", :pick => :one
      q "I would find hard not to do it.", :pick => :one
      q "I have no need to think about doing.", :pick => :one
      q "That's typically \"me\".", :pick => :one
      q "I have being doing for a long time.", :pick => :one
    end
    
    grid "Being physically active is something....." do
      a "1 = Fully Disagree"
      a "2 = Quite Disagree"
      a "3 = Somewhat Disagree"
      a "4 = Neither Agree Nor Disagree"
      a "5 = Somewhat Agree"
      a "6 = Quite Agree"
      a "7 = Fully Agree"
      q "I do frequently" , :pick => :one
      q "I do automatically.", :pick => :one
      q "I do without having to consciously remember.", :pick => :one
      q "That makes me feel weird if I do not do it.", :pick => :one
      q "I do without thinking.", :pick => :one
      q "That would require effort NOT to do it.", :pick => :one
      q "That belongs to my (daily, weekly, monthly) routine.", :pick => :one
      q "I start doing before I realize I'm doing it.", :pick => :one
      q "I would find hard not to do it.", :pick => :one
      q "I have no need to think about doing.", :pick => :one
      q "That's typically \"me\".", :pick => :one
      q "I have being doing for a long time.", :pick => :one
    end

  end
end                                   