class Polgenin < ApplicationRecord


	self.table_name = "gipi_polgenin"
	self.primary_key = "policy_id"

	alias_attribute :polgenin_pol_id, :policy_id
	alias_attribute :polgenin_gen_info, :gen_info
	alias_attribute :polgenin_gen_info1, :gen_info01
	alias_attribute :polgenin_initial_info, :initial_info01

	belongs_to :policy, foreign_key: :policy_id

	def travel_class
		/schengen|worldwide|asian/i.match(polgenin_gen_info1).to_s
	end
def destination_regex

				txt= self.polgenin_initial_info.to_s

			re1='.*?'	# Non-greedy match on filler
			re2='\\s+'	# Uninteresting: ws
			re3='.*?'	# Non-greedy match on filler
			re4='(\\s+)'	# White Space 1
			re5='(.)'	# Any Single Character 1
			re6='(.)'	# Any Single Character 2
			re7='(.)'	# Any Single Character 3
			re8='(.)'	# Any Single Character 4
			re9='(.)'	# Any Single Character 5
			re10='(.)'	# Any Single Character 6
			re11='(\\s+)'	# White Space 2
			re12='(-)'	# Any Single Character 7
			re13='(\\s+)'	# White Space 3
			re14='(.)'	# Any Single Character 8
			re15='(.)'	# Any Single Character 9
			re16='(.)'	# Any Single Character 10
			re17='(.)'	# Any Single Character 11
			re18='(.)'	# Any Single Character 12
			re19='(.)'	# Any Single Character 13
			re20='(.)'	# Any Single Character 14
			re21='(.)'	# Any Single Character 15
			re22='(.)'	# Any Single Character 16
			re23='(.)'	# Any Single Character 17
			re24='(.)'	# Any Single Character 18
			re25='(\\s+)'	# White Space 4
			re26='(-)'	# Any Single Character 19
			re27='(\\s+)'	# White Space 5
			re28='(.)'	# Any Single Character 20
			re29='(.)'	# Any Single Character 21
			re30='(.)'	# Any Single Character 22
			re31='(.)'	# Any Single Character 23
			re32='(.)'	# Any Single Character 24
			re33='(.)'	# Any Single Character 25

			re=(re1+re2+re3+re4+re5+re6+re7+re8+re9+re10+re11+re12+re13+re14+re15+re16+re17+re18+re19+re20+re21+re22+re23+re24+re25+re26+re27+re28+re29+re30+re31+re32+re33)
			m=Regexp.new(re,Regexp::IGNORECASE);
			if m.match(txt)
			    ws1=m.match(txt)[1];
			    c1=m.match(txt)[2];
			    c2=m.match(txt)[3];
			    c3=m.match(txt)[4];
			    c4=m.match(txt)[5];
			    c5=m.match(txt)[6];
			    c6=m.match(txt)[7];
			    ws2=m.match(txt)[8];
			    c7=m.match(txt)[9];
			    ws3=m.match(txt)[10];
			    c8=m.match(txt)[11];
			    c9=m.match(txt)[12];
			    c10=m.match(txt)[13];
			    c11=m.match(txt)[14];
			    c12=m.match(txt)[15];
			    c13=m.match(txt)[16];
			    c14=m.match(txt)[17];
			    c15=m.match(txt)[18];
			    c16=m.match(txt)[19];
			    c17=m.match(txt)[20];
			    c18=m.match(txt)[21];
			    ws4=m.match(txt)[22];
			    c19=m.match(txt)[23];
			    ws5=m.match(txt)[24];
			    c20=m.match(txt)[25];
			    c21=m.match(txt)[26];
			    c22=m.match(txt)[27];
			    c23=m.match(txt)[28];
			    c24=m.match(txt)[29];
			    c25=m.match(txt)[30];
			    print "("<<ws1<<")"<<"("<<c1<<")"<<"("<<c2<<")"<<"("<<c3<<")"<<"("<<c4<<")"<<"("<<c5<<")"<<"("<<c6<<")"<<"("<<ws2<<")"<<"("<<c7<<")"<<"("<<ws3<<")"<<"("<<c8<<")"<<"("<<c9<<")"<<"("<<c10<<")"<<"("<<c11<<")"<<"("<<c12<<")"<<"("<<c13<<")"<<"("<<c14<<")"<<"("<<c15<<")"<<"("<<c16<<")"<<"("<<c17<<")"<<"("<<c18<<")"<<"("<<ws4<<")"<<"("<<c19<<")"<<"("<<ws5<<")"<<"("<<c20<<")"<<"("<<c21<<")"<<"("<<c22<<")"<<"("<<c23<<")"<<"("<<c24<<")"<<"("<<c25<<")"<< "\n"
		end
	end
end
