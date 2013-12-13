#!/usr/bin/ruby  -w
require 'find'

filename=""
filename=Array.new(10)
i=0
ARGV.each do|arg|
filename[i]=arg
i=i+1
end
$code_path="https://github.com/xyongcn/Kernel3.5.4Analysis/blob/master/" #the base address of the node code 
sfile=File.new(filename[0],"r")
$lines=[]
color=["blue","red","green","black","#8b5742","chocolate"]

$aline="\<g\nid\=\"layer2\"\>\n" # the layers of the edges
$bline="\<g\nid\=\"layer3\"\>\n"
$cline="\<g\nid\=\"layer4\"\>\n"
$dline="\<g\nid\=\"layer5\"\>\n"
$eline="\<g\nid\=\"layer6\"\>\n"
$fline="\<g\nid\=\"layer7\"\>\n"
$papo_index="\<set attributeName=\"opacity\" to=\"0.5\" begin=\"XXXX.mouseover\" dur=\"3s\"/><set attributeName=\"stroke\" to=\"red\" begin=\"XXXX.mouseover\" dur=\"3s\"/><set attributeName=\"stroke-width\" to=\"4\" begin=\"XXXX.mouseover\" dur=\"3s\"/>" #added 20130827 make the polygon and path thick and to red and last three seconds
$make_zoom="&amp;checkbox1=checkbox" # added 20130828 make the graph zoom
$make_click="<set attributeName=\"opacity\" to=\"0.7\" begin=\"XXXX.mouseover\" dur=\"3s\"/>" #added 20130827 make the number be clicked 
module Readlayer 
        def Readlayer.col(lins) 
             pre=Readlayer.rem(lins)
              sline=lins.split("\n")
		for i in 0..sline.size-1
		   ss=sline[i].split(" ")
		   for i in 0..ss.size-1
			   if ss.index("fill\=\"none\"")
			       s=ss[ss.index("fill\=\"none\"")+1]
				a=Readlayer.getstr(s)
			   end
		     end

		 end 
              #######to edge to change 20130314
              pre=Edge.hre(pre).to_s  
              color=["blue","red","green","black","#8b5742","chocolate"] 
	      if color.index(a)==0
		 $aline+=pre
	      end
	      if color.index(a)==1
		 $bline+=pre
	     end
	      if color.index(a)==2
		 $cline+=pre
	     end
	      if color.index(a)==3
		 $dline+=pre
	     end
	      if color.index(a)==4
		 $eline+=pre
	     end
	      if color.index(a)==5
		 $fline+=pre
	     end
        end

     def Readlayer.getstr(s)
          pos1=s.index("\"")
          pos2=s.rindex("\"")
	  a=s.slice(pos1+1,pos2-pos1-1)
     end

     def Readlayer.rem(lines) # the action to the ending </svg> and </g>
             n=0
             klines=""
           sline=lines.split("\n") # divided to elements of the array
        for i in 0..sline.size-1
             if sline[i].index("\<\/g\>")
                 n=n+1 #calculate the number of the </g> in one node part
             end
	end 
        if n==1
           klines=lines    
        end
        if n==2 # make the </g>=1 in one node part
           for i in 0..sline.size-3
              klines+=sline[i]+"\n"
            end    
        end 
        return klines
     end

end
#####20130315 the action to nodes####################################
module Node
      def Node.hre(t)
         if t!=nil
             s=t.split("\n")
             for i in 0..s.size-1
                  s[i]=s[i]+"\n"
                  if s[i].index("\<a xlink\:href\=")
                        k=s[i].chop.split("\"")
                         link=k[1]  # the futher callgraph link 
                         name=k[3]
                         kk=s[i].split("\"")  
                         name=name.gsub!(" ","") #the name of the node
                        # puts link
                        # puts name
                         s[i]=""
                         s[i]="\<a xlink\:title\=\""+"#{kk[3]}"+"\"\>\n"

                  end
                  if s[i].index("\<ellipse") #added 20130318
                      ll=s[i].chop.split(" ")
                       for i in 0..ll.size-1
                            if ll[i].index("cx\=")
                               tx=Readlayer.getstr(ll[i])
                            end
                            if ll[i].index("cy\=")
                               ty=Readlayer.getstr(ll[i])
                            end
                       end
                   # puts tx
                   # puts ty
                  end

    #              if s[i].index("\<\/a\>")
    #                  s[i]=""
    #              end
             end
            for i in 0..s.size-1
                   if s[i].index("class\=\"node\"")
                      sadd=s[i].chop.split("\>\<")
                      s[i]="#{sadd[0]}"+" onclick\=\"creatmenu\(evt\,"+"#{tx}"+"\,"+"#{ty}+20"+"\,\'"+"#{link}"+"\'\,\'"+$code_path+"#{name}"+"\'\,\'"+"#{link}"+$make_zoom+"\'\)\""+"\>\<"+"#{sadd[1]}"+"\n"
                     # puts "********#{s[i]}&&&&&&&&&&&&&"
                  end
            end

          else
          end
         return s
      end
end
############the action to edges ####################
module Edge
       def Edge.hre(t)
           if t!=nil
             s=t.split("\n")
             for i in 0..s.size-1
                s[i]=s[i]+"\n"
                 if s[i].index("\<a xlink\:href\=")
                    k=s[i].chop.split("\"")
                    link=k[1]
                    
                    name=link.gsub("watchfuc","callgraph")  
                    s[i]="\<a xlink\:title\=\""+"#{k[3]}"+"\"\>\n"
                    link_1=k[3]
                  end   
                 if s[i].index("\<text") #added 20130318
                      ll=s[i].chop.split(" ")
                       for i in 0..ll.size-1
                            if ll[i].index("x\=")
                               tx=Readlayer.getstr(ll[i])
                            end
                            if ll[i].index("y\=") and !ll[i].index("font\-family\=")
                               #puts ll[i]
                               ty=Readlayer.getstr(ll[i])
                              # puts ty
                            end
                       end
                  end
                #######added 20130827 find the ID of the edge 
                if s[i].index("class=\"edge\"")
                    sp_s=s[i].chop.split(" ")
                    edg_id=Readlayer.getstr(sp_s[1]) #added 20130827 the id of the edge
                   # puts edg_id           
                end
                #######added 20130827 find the ID of the edge
             end
            for i in 0..s.size-1
                   if s[i].index("class\=\"edge\"")
                      sadd=s[i].chop.split("\>\<")
                      s[i]="#{sadd[0]}"+" onclick\=\"edgemenu\(evt\,"+"#{tx}"+"\,"+"#{ty}"+"\,\'"+"#{link}"+"\'\,\'"+"#{name}"+"\'\,\'"+"#{name}"+$make_zoom+"\'\,\'"+edg_id+"\'\)\""+"\>\<"+"#{sadd[1]}"+"\n"
                    # puts "********#{s[i]}&&&&&&&&&&&&&"
                  end
=begin
                  if s[i].index("<path") ###to the path of the edge to thick and to red
                     s[i]=s[i].gsub("/>",">")
                     s[i]=s[i]+$papo_index+"</path>"+"\n"
                     s[i]=s[i].gsub("XXXX","#{edg_id}")
                  end
 
                  if s[i].index("\<polygon") ###to the polygon of the edge to thick and to red
                     s[i]=s[i].gsub("/>",">")
                     s[i]=s[i].chop+$papo_index+"</polygon>"+"\n"
                     s[i]=s[i].gsub("XXXX","#{edg_id}")
                  end
                  
                  if s[i].index("<text") #to the test 
                     s[i]=s[i].gsub("</text>","")
                     s[i]=s[i].gsub("/>",">")
                     s[i]=s[i].chop+$make_click+"</text>"+"\n"
                     s[i]=s[i].gsub("XXXX","#{edg_id}")
                  end                 
=end          
            end

          else
          end
         return s
       end
end

#####20130315####################################
afile=File.new("/usr/local/share/db-rtl/lxr/script","r")
$slines=[]
rectlines=""
while line=afile.gets
      $slines=$slines.concat([line])
end
for i in 0..$slines.size-1
    if $slines[i].index("\<\/script\>")
       ss=i
    end
end



$nline="\<g\nid\=\"layer1\"\>\n"
$temp=""
templine=""
etempline=""
while line=sfile.gets
      $lines=$lines.concat([line])
  if line.index("\<\!--")  
          pre=line
          nflag=0
          eflag=0
  end
  if line.index("\<g") and line.index("class=\"node\"\>\<title\>")
          templine=Readlayer.rem(templine)
         #  puts templine
          templine=Node.hre(templine)  #added 20130315
           #templine=Readlayer.rem(templine)
          $temp+=templine.to_s      #added 20130315
          
            templine=""
            templine+=pre 
            nflag=1
  end
  if line.index("\<g") and line.index("class=\"edge\"\>\<title\>")
          #edline+=etempline
            Readlayer.col(etempline)
            etempline=""
            etempline+=pre
            eflag=1
  end
    if nflag==1
        templine+=line 
    end
    if eflag==1
       etempline+=line
    end
 end
templine=Readlayer.rem(templine)
templine=Node.hre(templine)  #added 20130315
$temp+=templine.to_s          #added 20130315
Readlayer.col(etempline)


for i in 0..$lines.size-1
    if $lines[i].index("\<g id\=\"graph1\"")
        n=i
    end
    if $lines[i].index("\<polygon fill\=\"white\"")
        eeline=$lines[i].split(",")
        ee=eeline[2].split(" ")[0].to_i
        max=eeline[2].split(" ")[1].to_i #added 20130321
        m=i
        kk=ee
     end
end

y=[]
t=[]
for i in 0..6
     y[i]=ee
     t[i]=ee+20
    # puts ee
     ee=ee+32
end
y[7]=kk
t[7]=kk+20

for i in ss+1..$slines.size-1
       #if $slines[i].index(" y\=")
      if $slines[i].index("XXXXX1")
         $slines[i].gsub!("XXXXX1",y[0].to_s)
      elsif $slines[i].index("XXXXX2")
          $slines[i].gsub!("XXXXX2",t[0].to_s)
      elsif $slines[i].index("XXXXX3")
          $slines[i].gsub!("XXXXX3",y[1].to_s)
      elsif $slines[i].index("XXXXX4")
          $slines[i].gsub!("XXXXX4",t[1].to_s)
      elsif $slines[i].index("XXXXX5")
          $slines[i].gsub!("XXXXX5",y[2].to_s)
      elsif $slines[i].index("XXXXX6")
          $slines[i].gsub!("XXXXX6",t[2].to_s)
      elsif $slines[i].index("XXXXX7")
          $slines[i].gsub!("XXXXX7",y[3].to_s)
      elsif $slines[i].index("XXXXX8")
          $slines[i].gsub!("XXXXX8",t[3].to_s)
      elsif $slines[i].index("XXXXX9")
          $slines[i].gsub!("XXXXX9",y[4].to_s)
      elsif $slines[i].index("XXXXXA")
          $slines[i].gsub!("XXXXXA",t[4].to_s)
      elsif $slines[i].index("XXXXXB")
          $slines[i].gsub!("XXXXXB",y[5].to_s)
      elsif $slines[i].index("XXXXXC")
          $slines[i].gsub!("XXXXXC",t[5].to_s)
      elsif $slines[i].index("XXXXXD")
          $slines[i].gsub!("XXXXXD",y[6].to_s)
      elsif $slines[i].index("XXXXXE")
          $slines[i].gsub!("XXXXXE",t[6].to_s)
      elsif $slines[i].index("XXXXXF")
          $slines[i].gsub!("XXXXXF",y[7].to_s)
      else
      end
     rectlines+=$slines[i]
     #puts $slines[i]
end


$nline+=rectlines
$nline+=$temp
#puts e
sfile.close






wfile=File.new(filename[1],"w")
 #图片的头1  
for i in 0..n-1
    wfile.puts $lines[i]
     
end  

#script lines
for i in 0..ss
    if $slines[i].index("XXXA")
       $slines[i].gsub!("XXXA",kk.to_s)
    end
    if $slines[i].index("XXXB")        #added 20130321
       $slines[i].gsub!("XXXB",max.to_s)
       #puts $slines[i]
    end
    wfile.puts $slines[i]
end

#图片的头2
for i in n..m
    wfile.puts $lines[i]
end

n=[$nline,$aline,$bline,$cline,$dline,$eline,$fline]
for i in 0..n.size-1
     wfile.puts n[i]
     wfile.puts "\<\/g\>" 
end
wfile.puts "\<\/g\>"
wfile.puts "\<\/svg\>"

wfile.close

afile.close
