#!/usr/bin/perl
#  UNIFICATEUR DE GRAPHIES NAWATL
#  Copyright (C) 2025 JUAN JOSE GUZMAN LANDA & JUAN-MANUEL TORRES-MORENO 
#----------------------------------------------------------------------------------------------------------------------
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of the GNU General Public License
#  as published by the Free Software Foundation; either version 2
#  of the License, or any later version.
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
#----------------------------------------------------------------------------------------------------------------------
# Contact : JUAN-MANUEL TORRES MORENO, LIA-UNIVERSITE D'AVIGNON - BP 91228 F-84911 AVIGNON CEDEX 09 FRANCE						
# juan-manuel.torres@univ-avignon.fr & juan-jose.guzman-landa@univ-avignon.fr                        						
# Version:	0.090
# Création:	25.02.25
# Modification:	25.06.12
# Regles d'unification: Miguel Figueroa-Saavedra Ruiz migfigueroa@uv.mx
# Utilisation: perl ./unigraphie_jm.pl < text_nawatl.txt   ou  cat REP/*txt | perl ./unigraphie_jm.pl 
#             chmod +x unigraphie.pl ;  ./unigraphie_jm.pl < text_nawatl.txt  ou   cat REP/*txt | ./unigraphie_jm.pl 
#----------------------------------------------------------------------------------------------------------------------
use strict;
use warnings;
use utf8;
binmode(STDOUT, ":utf8"); binmode(STDIN, ":encoding(utf8)"); 	# UTF-8
my $voyelle='[aeiou]';  my $consonne='[bcdfghjklmnpqrstvwxyz]'; my $LIM='[ \s\¿\?\¡\!\)\.,;:"]';	# Delim de mot
while (<>) {								# Leer desde STDIN línea a línea
	next if m/^\s*#/;						# Eviter commentaires
	$_ = " ".$_;
	s/(\w)´($LIM)/$1h$2/g; s/´//g;			# Saltillo ? et Saltillo isolé
	s/\xe2\x80\x99//g;						# Caracteres invisibles y ’
	s/\xc2(\x93|\x94|\x97)//g;				# Caracteres de controle
	s/\xc2(\x93|\x94|\x97)//g;				# Caracteres de controle	
	s/­//g; s/​​//g;  s/​//g;					# Caracteres invisibles!
	s/([a-z])\.([A-Z])/$1. $2/ig; 			# Lettres collés Noé.Iwan -> Noe. Iwan
	s/…/.../g; s/(“|”|«|»)/"/g;   s/'//g;  s/‘//g;  s/’//g;	 			# Normalisation de symboles
	s/ª/a/g;   s/°/o /g; s/º/o/g; s/•/-/g; s/—/-/g; s/–/-/g; s/―/-/g; 	# Normalisation de symboles		

																		# Accents	29, 31, 32
	s/[ãàáā]/a/ig;  s/[ĀÁ]/A/g; s/[èéēẽe̱]/e/ig; s/[ĒÉ]/E/g; s/[íīì]/i/ig; s/[ĪÍ]/I/g; 
	s/[òóōöo̱]/o/ig; s/[ŌÓ]/O/g; s/[ÜÚ]/U/g;  s/[ùúūü]/u/ig; 
	s/[âȃ]/ah/ig;		s/ê/eh/ig;   s/î/ih/ig; s/ô/oh/ig; 				# â ê î ô → ah eh ih oh   30
	s/Ç/S/g; s/ç/s/g;   s/č/c/g;     s/š/s/g;   s/ħ/h/g;  s/[ỹŷÿ]/y/g; 	# Ç→S ç→s ħ→h ỹ|ŷ|ÿ→y     33	
	s/a\[n\]/an/ig;							# ihua[n] - ihuan			34	paleographie desagun_codice_1539_otro.txt
	s/($voyelle):(\w)/$1$2/ig;				# voc:lettre → voc+lettre	35.	a:tl -> atl  paleographie Axolotl_version

	s/hu($voyelle)/w$1/g;					# hu + voc → w + voc		1
	s/($voyelle)uh/$1w/ig;					# voc + uh → voc +  w		2
	s/qua/kua/g;							# qua → kua					3	
	s/qu([ei])/k$1/ig;    					# que → ke    qui → ki		4	
	s/($LIM|$voyelle)u($voyelle)/$1w$2/ig; 	# u → w                     5 
	s/c([aou])/k$1/g; 						# ca|co|cu → ka|ko|ku       6
	s/kw/ku/ig;								# kw → ku                   7	
	s/uk($voyelle)/ku$1/ig;					# uk → ku                   8 
	s/([^tiy])c([^hei])/$1k$2/ig;			# No TIY seguido de C y no (H, E, I): C -> K  9
	s/($consonne)y(\w)/$1i$2/ig;			# cons + y + lettre → cons + i + lettre	10 
	s/($voyelle)j(\w|$LIM)/$1h$2/ig;		# voc + j + (lettre ou LIM) → voc + h + (lettre ou LIM)	11
	s/(ywan|yoan|ioan)/iwan/ig;				# ywan|yoan|ioan → iwan					12
	s/($LIM)wan($LIM)/$1iwan$2/ig;			# LIM + wan + LIM → LIM + iwan + LIM	13 	
	s/y(c|n)/i$1/ig;						# yn → in yc → ic	14
	s/[cçz]([ei])/s$1/ig; 					# ce|ze|çe → se; ci|çi|zi → si; 15
	s/[çz]o/so/ig; 							# zo|ço → so                	16	
	s/t[zcç]/ts/ig;							# tz | tc | tç → ts				17	
	s/[zcç]t/st/ig;							# zt | ct | çt → st				17' iztac -> istak	
	s/[lh]l/l/ig;							# ll → l, hl → l				18    huajlau -> wahlau -> walau COORECTE?
	s/($voyelle)\1/$1/ig; 					# aa→a, ee→e, ii→i, oo→o, uu→u 	25	\1 = caractere repété   Avant 18
	s/($LIM)i($voyelle)/$1y$2/g;			# LIM + i + voc → LIM + y + voc	19
	s/($LIM|$consonne)u($consonne)/$1o$2/ig;# (LIM ou cons) + u + cons → (LIM ou cons) + o + cons	20.
	s/[çz]([ae])/s$1/g; 					# za|ça → sa   ze|çe → se		21, 22	
	s/($LIM)(pan|tech)($LIM)/$1i$2$3/ig;	# LIM + pan|tech + LIM → LIM + ipan|itech + LIM		23 		
	s/($LIM)y(pan|tech)($LIM)/$1i$2$3/ig;	# LIM + y(pan|tech) + LIM → LIM + ipan|itech + LIM	24 	
	s/($LIM)h([aeio])/$1$2h/ig;				# ha → ah, he → eh, hi → ih,  ho → oh		26
	s/($LIM)(ah|ha|aj)mo($LIM)/$1amo$3/ig;	# LIM ahmo, hamo , ajmo LIM→ LIM amo LIM	27    
	s/($voyelle)chu($voyelle)/$1kw$2/ig;	# voc + chu + voc → voc + ku + voc		28

	s/([a-z])\. ([a-z])/$1. \U$2/g; 		# Lettres majuscules		37.	Noé.Iwan -> Noe. Iwan

#---------- Unification des varietes
	s/($LIM)ey($LIM)/$1eyi$2/ig;			# ey → eyi  
	s/($LIM)mochioa($LIM)/$1mochiwa$2/ig;	# mochioa → mochiwa
	s/chikue(i|y)($LIM)/chikueyi$2/ig;	    # chicuei → chicueyi
	s/($LIM)ipampa($LIM)/$1pampa$2/ig;		# ipampa → pampa
	s/($LIM)miak($LIM)/$1miyak$2/ig;		# miak → miyak
	#s/($LIM)nepa($LIM)/$1nopa$2/ig;		# nepa → nopa
	#s/($LIM)tlein($LIM)/$1tlen$2/ig;		# tlein → tlen

	s/^\s*//;

	print ;
}
