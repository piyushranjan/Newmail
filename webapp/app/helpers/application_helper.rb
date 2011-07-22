# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def displayTags(tags)
    last_tag_alphabet, str = nil, ""
    tags.collect{|tag|
      if last_tag_alphabet!=tag.name[0]
        last_tag_alphabet=tag.name[0]
        str+= "</dd>" if str.length>0
        str+= "<dt>#{last_tag_alphabet.chr.upcase}</dt><dd><a href=''>#{tag.name}</a>"
      else
        str+= ", <a href=''>#{tag.name}</a>"
      end
    }
    return str
  end
end
