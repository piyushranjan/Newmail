module MailboxesHelper
  def writeFroms(ticket)
    if ticket and ticket.mail_tickets_count>1
      if ticket.mail_tickets_count==2 
        if ticket.mails.first.froms[0] == ticket.mails.last.froms.first
          truncate(ticket.mails.last.froms.first.person.name, :limit => 20)          
        else
          truncate(ticket.mails.first.froms[0].person.name+", "+ticket.mails.last.froms.first.person.name, :limit => 20)
        end
      else 
        truncate(ticket.mails.first.froms[0].person.name+" .. "+ticket.mails.last.froms.first.person.name, :limit => 20)
      end
    else
      truncate((ticket.mails.first.froms.first ? (ticket.mails.last.froms.first.person.name) : "No one"), :limit => 20)
    end
  end

  def getStartPage(page)
    if page
      page.to_i
    else
      1
    end
  end

  def getPages(totalPages)
    if totalPages>4
      4
    else
      totalPages
    end
  end
    
  def getPaginationLinks(current_page, maximum)
    str=""
    current_page = getStartPage(current_page)
    getPaginationArray(current_page, maximum).collect{|page|
      if page==".."
        str+="<li class='dots'>..</li>"
      else
        str+="<li><a href=\"#page=#{page}\" class=\"#{"here" if current_page==page}\" id=\"page_#{page}\">#{page}</a></li>"
      end
    }
    str
  end

  #takes current_page and maximum to produce pagination array
  def getPaginationArray(current_page, maximum, window = WINDOW, minimum = 1)
    return((minimum+window<current_page ? minimum.upto(window).collect : minimum.upto(current_page+window).collect) + (current_page-window > minimum+window ? [".."] : []) + (current_page>minimum+window ? (current_page-window > minimum+window ? current_page-window : minimum+window).upto(current_page+window > maximum ? maximum : current_page+window).collect : [])+(current_page+window+1<maximum-window ? [".."] : [])+(current_page<maximum-2*window ? maximum-window : current_page+window+1).upto(maximum).collect)
  end

end
