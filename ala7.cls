%%
%% This is file `apa7.cls',
%%
%% Modified by Leopold Zhou (@am1006) based on the original apa7.cls
%%
%% The original source files were:
%%
%% apa7.dtx  (with options: `class')
%% ----------------------------------------------------------------------
%%
%% LICENSE INFORMATION
%% 
%% apa7 - A LaTeX class for formatting documents in compliance with the
%% American Psychological Association's Publication Manual, 7th edition
%% 
%% Copyright (C) 2022 by Daniel A. Weiss <daniel.weiss.led at gmail.com>
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License (LPPL), either
%% version 1.3c of this license or (at your option) any later
%% version.  The latest version of this license is in the file:
%% 
%% http://www.latex-project.org/lppl.txt
%% 
%% Users may freely modify these files without permission, as long as the
%% copyright line and this statement are maintained intact.
%% 
%% This work is not endorsed by, affiliated with, or probably even known
%% by, the American Psychological Association.
%% 
%% ----------------------------------------------------------------------
%% 
\ProvidesClass{ala7}[2023/09/26 v1.0; adapted from 2022/07/25 v2.16 APA formatting (7th edition)]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption{thesis}{%
  \def\def@thesis{\@thesismode}
}

\DeclareOption{stu}{%
  \def\def@stu{\@stumode}
  \def\def@thesis{\@thesismode}
}

\DeclareOption{jou}{%
  \def\def@jou{\@joumode}
}

\DeclareOption{doc}{%
  \def\def@doc{\@docmode}
}

\DeclareOption{babel}{%
  \def\def@babel{\@babel}
}

\DeclareOption{notimes}{%
  \@ifundefined{def@jou}{}{\def\def@notimes{\@notimes}}
}

\DeclareOption{notxfonts}{% -- thp 2005/07/23
  \@ifundefined{def@jou}{}{\def\def@notxfonts{\@notxfonts}}
}

\DeclareOption{nosf}{%
  \@ifundefined{def@thesis}{}{\def\def@nosf{\@nosf}}
}

\DeclareOption{fignum}{%
  \@ifundefined{def@thesis}{}{\def\fig@num{\relax}}
}


\DeclareOption{longtable}{%
  \def\long@table{\relax}
}

\DeclareOption{tt}{%
  \@ifundefined{def@thesis}{}{\def\tt@family{\relax}}
}

\DeclareOption{helv}{%
  \@ifundefined{def@thesis}{}{\def\helv@family{\relax}}
}

\DeclareOption{notab}{\def\no@tab{\relax}}

\DeclareOption{nobf}{\def\no@bf@title{\relax}}

\DeclareOption{nolmodern}{%
  \def\def@nolmodern{\@nolmodernmode}
}

\DeclareOption{nofontenc}{%
  \def\def@nofontenc{\@nofontencmode}
}

% remove extra space around headings, etc., in thesis mode
\DeclareOption{noextraspace}{%
  \ClassError{ala7}{Option removed: no longer uses as of version  2.15}{Spacing updated to more closely match APA 7th Edition Manual}
}

% suppress the title at the introduction (in case a different title is desired)
\DeclareOption{donotrepeattitle}{%
  \def\def@donotrepeattitle{\@donotrepeattitlemode}
}

\DeclareOption{floatsintext}{%
  \def\def@floatsintext{\@floatsintext}
}

\DeclareOption{a4paper}{%
  \def\def@aFourPaper{\@aFourPapermode}
}

\DeclareOption{apacite}{% BDB
  \def\def@apacite{\@apacitemode}
}

\DeclareOption{natbib}{% BDB
  \def\def@natbib{\@natbibmode}
}

\DeclareOption{biblatex}{% BDB
  \def\def@biblatex{\@biblatexmode}
}

\DeclareOption{draftfirst}{% BDB
  \def\def@draftfirst{\@draftfirstmode}
}

\DeclareOption{draftall}{% BDB
  \def\def@draftall{\@draftallmode}
}

\DeclareOption{mask}{\def\apaSeven@maskauthoridentity{\relax}}  % BDB

\newcommand\apaSeven@ptsize{}
\newcommand\apaSeven@noptsize{}
\DeclareOption{10pt}{\renewcommand\apaSeven@ptsize{10pt}}
\DeclareOption{11pt}{\renewcommand\apaSeven@ptsize{11pt}}
\DeclareOption{12pt}{\renewcommand\apaSeven@ptsize{12pt}}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}

\ProcessOptions\relax

% make thesis the default if no other options have been specified
\@ifundefined{def@thesis}{%
   \def\def@thesis{\@thesismode}
   \ClassInfo{ala7}{Using default mode (thesis)}
}{}

% pass the default font-size to the report class
\@ifundefined{def@thesis}{}
{% thesis
  \ifx\apaSeven@ptsize\apaSeven@noptsize
    \LoadClass[12pt,twoside]{report} % default for thesis is 12pt
  \else
    \LoadClass[\apaSeven@ptsize]{report}
  \fi
}


% determine the bibliography package, and load it if selected through the appropriate \documentclass option
\@ifundefined{def@apacite}{%
  \@ifundefined{def@natbib}{%
    \@ifundefined{def@biblatex}{%
      \def\def@biblatex{\@biblatexmode}%  the default bibliography package is biblatex
      \RequirePackage{etoolbox}
      \AtEndPreamble{%
        \@ifpackageloaded{biblatex}{%  the user has loaded biblatex
          \@ifundefined{def@thesis}{%
            \defbibheading{bibliography}[\refname]{\section*{\normalfont\textbf{#1}}}%
          }{%
            \defbibheading{bibliography}[\refname]{\clearpage\section*{\normalfont\textbf{#1}}}%
          }
        }{}
      }
      \ClassInfo{ala7}{No bibliography package was specified; defaulting to (but not loading) Biblatex}
    }{%
      \def\def@biblatex{\@biblatexmode}%  the selected bibliography package is Biblatex
      \RequirePackage[style=apa,backend=biber]{biblatex}
      \@ifundefined{def@thesis}{%
        \defbibheading{bibliography}[\refname]{\section*{\normalfont\textbf{#1}}}%
      }{%
        \defbibheading{bibliography}[\refname]{\clearpage\section*{\normalfont\textbf{#1}}}%
      }
      \ClassInfo{ala7}{The selected bibliography package, biblatex, has been loaded}
    }
  }{%
    \def\def@natbib{\@natbibmode}%  the selected bibliography package is natbib (with apacite)
    \@ifundefined{def@thesis}{%         -- thp 2005/07/23
      \RequirePackage[natbibapa]{apacite}[2012/02/25]}
      {\RequirePackage[natbibapa,bibnewpage]{apacite}[2012/02/25]}
    \ClassInfo{ala7}{The selected bibliography package, apacite and
      natbib, have been loaded}
  }
}{%
  \def\def@apacite{\@apacitemode}%  the selected bibliography package is apacite
  \@ifundefined{def@thesis}{%         -- thp 2005/07/23
    \RequirePackage{apacite}[2005/06/08]}
    {\RequirePackage[bibnewpage]{apacite}[2005/06/08]}
  \ClassInfo{ala7}{The selected bibliography package, apacite, has been loaded}
}

% load the lmodern package (needed for proper watermark font size)
\@ifundefined{def@nolmodern}{%
  \RequirePackage{lmodern}
}{}

% load the fontenc package (needed for proper hyphenation of accented characters)
\@ifundefined{def@nofontenc}{%
  \RequirePackage[T1]{fontenc}
}{}

% place a watermark on any pages indicated
\@ifundefined{def@draftall}{%
  \@ifundefined{def@draftfirst}{}{%
    \RequirePackage[firstpage]{draftwatermark}
    \SetWatermarkText{DRAFT}
  }
}{%
% a draft watermark has been requested for all pages
\RequirePackage{draftwatermark}
  \SetWatermarkText{DRAFT}
}


%==== Conditional compilation macros depending on mode ====

\long\def\ifapamodethesis#1#2{\@ifundefined{def@thesis}{#2}{#1}}
\long\def\ifapamode#1#2#3{%
 \@ifundefined{def@thesis}{%
   \@ifundefined{def@jou}{%
    \@ifundefined{def@doc}{\ClassError{ala7}{Undefined mode state!}}{#3}%
   }{#2}%
  }{#1}%
}

%=================================================================
\@ifundefined{def@thesis}{}{%
%
% endnotes and endfloat loaded later
% longtable must be loaded before endfloat
%
\@ifundefined{long@table}{}{%
 \RequirePackage{array}
 \RequirePackage{longtable}
}% END of loading longtable
\@ifundefined{tt@family}{}{%
 \DeclareFontShape{OT1}{cmtt}{bx}{n}{ <-> cmssbx10 }{}  % probably not the
 \DeclareFontShape{OT1}{cmtt}{bx}{it}{ <-> cmssbxo10}{} % right way to do it
 \renewcommand{\familydefault}{cmtt}
 }
\@ifundefined{helv@family}{}{%
 \renewcommand{\familydefault}{phv}}
}

% choose a paper size and set the page margins
\@ifundefined{def@aFourPaper}{
  \RequirePackage[top=1in, bottom=1in, left=1in, right=1in]{geometry}
}{
  \RequirePackage[top=1in, bottom=1in, left=1in, right=1in,a4paper]{geometry}
}

\RequirePackage{graphicx}  % this is for including graphics

\RequirePackage{scalerel,tikz,hyperref} % this is included for ORCID icon
\usetikzlibrary{svg.path}
\definecolor{orcidlogocol}{HTML}{A6CE39}
\tikzset{
  orcidlogo/.pic={
    \fill[orcidlogocol] svg{M256,128c0,70.7-57.3,128-128,128C57.3,256,0,198.7,0,128C0,57.3,57.3,0,128,0C198.7,0,256,57.3,256,128z};
    \fill[white] svg{M86.3,186.2H70.9V79.1h15.4v48.4V186.2z}
                 svg{M108.9,79.1h41.6c39.6,0,57,28.3,57,53.6c0,27.5-21.5,53.6-56.8,53.6h-41.8V79.1z M124.3,172.4h24.5c34.9,0,42.9-26.5,42.9-39.7c0-21.5-13.7-39.7-43.7-39.7h-23.7V172.4z}
                 svg{M88.7,56.8c0,5.5-4.5,10.1-10.1,10.1c-5.6,0-10.1-4.6-10.1-10.1c0-5.6,4.5-10.1,10.1-10.1C84.2,46.7,88.7,51.3,88.7,56.8z};
  }
}
\newcommand{\addORCIDlink}[2]{#1 \href{https://orcid.org/#2}{{\mbox{\scalerel*{
\begin{tikzpicture}[yscale=-1,transform shape]
\pic{orcidlogo};
\end{tikzpicture}
}{|}}} https://orcid.org/#2}}

\RequirePackage{booktabs}  % this is for nice-looking tables
\setlength{\abovetopsep}{0pt}  % set the distance between the table title and the table toprule
\setlength{\belowbottomsep}{0pt}  % set the distance between the table bottomrule and any notes

\RequirePackage[para,flushleft]{threeparttable}  % this is for nice-looking table footnotes, etc.
\@ifundefined{def@thesis}{% BDB
  \def\TPT@doparanotes{\par\vspace{-.5\baselineskip}% BDB
     \prevdepth\z@ \TPT@hsize
     \TPTnoteSettings
     \parindent\z@ \pretolerance 8
     \linepenalty 200
     \renewcommand\item[1][]{\relax\ifhmode \begingroup
         \unskip
         \advance\hsize 10em % \hsize is scratch register, based on real hsize
         \penalty -45 \hskip\z@\@plus\hsize \penalty-19
         \hskip .15\hsize \penalty 9999 \hskip-.15\hsize
         \hskip .01\hsize\@plus-\hsize\@minus.01\hsize
         \hskip 1em\@plus .3em
        \endgroup\fi
        \tnote{##1}\,\ignorespaces}%
     \let\TPToverlap\relax
     \def\endtablenotes{\par}%
  }
}{%
  \def\TPT@doparanotes{\par\vspace{-.4\baselineskip}% BDB
     \prevdepth\z@ \TPT@hsize
     \TPTnoteSettings
     \raggedright
     \parindent\z@ \pretolerance 8
     \linepenalty 200
     \renewcommand\item[1][]{\relax\ifhmode \begingroup
         \unskip
         \advance\hsize 10em % \hsize is scratch register, based on real hsize
         \penalty -45 \hskip\z@\@plus\hsize \penalty-19
         \hskip .15\hsize \penalty 9999 \hskip-.15\hsize
         \hskip .01\hsize\@plus-\hsize\@minus.01\hsize
         \hskip 1em\@plus .3em
        \endgroup\fi
        \tnote{##1}\,\ignorespaces}%
     \let\TPToverlap\relax
     \def\endtablenotes{\par}%
  }
}



%========= Language portability parameters ===========

% Language-specific definition of strings is handled externally -- thp 2005/12/30
% Based on handling of the same issue in apacite.sty

% First define the default American English macros in case no external file is present or needed
\def\lastauthorseparator{and}
\def\acksname{Author Note}
\def\keywordname{Keywords}
\def\notesname{Footnotes}
\def\notelabel{Note}

\AtBeginDocument{% so that we know what language is active in babel

                           % Unfortunately, because babel is built into the format
                           % in modern distributions, \iflanguage is defined and
                           % \languagename contains whichever language happens to be
                           % last in the definition list, whether or not the babel
                           % package is loaded by the current document

\@ifpackageloaded{babel}% this is defined only if the user requested loading babel
  {\def\@apaSeven@langfile{config/APA7\languagename.txt}}
  {\def\@apaSeven@langfile{config/APA7american.txt}}
 \InputIfFileExists{\@apaSeven@langfile}{}{%
  \ClassInfo{ala7}{Language definition file \@apaSeven@langfile\space not found}
 }%
}

%========== Load babel if required ===================

\@ifundefined{def@babel}{}{% -- thp 2005/07/23
 \RequirePackage{babel}    % -- thp 2005/07/23, removed options 2005/12/28
}

\@ifundefined{def@biblatex}{}{% BDB

  % we are using biblatex

    %%%%%%%%%%%% biblatex commands %%%%%%%%%%%%%%%%
    %%
    %%  \cite[e.g.,][p.~11]{vanDijk2001,Ross1987}          =>  e.g., van Dijk, 2001; Ross, 1987, p. 11
    %%  \Cite[e.g.,][p.~11]{vanDijk2001,Ross1987}          =>  e.g., Van Dijk, 2001; Ross, 1987, p. 11
    %%  \parencite[e.g.,][p.~11]{vanDijk2001,Ross1987}     =>  (e.g., van Dijk, 2001; Ross, 1987, p. 11)
    %%  \Parencite[e.g.,][p.~11]{vanDijk2001,Ross1987}     =>  (e.g., Van Dijk, 2001; Ross, 1987, p. 11)
    %%  \textcite[e.g.,][p.~11]{vanDijk2001,Ross1987}      =>  e.g., van Dijk (2001); Ross (1987, p. 11)
    %%  \Textcite[e.g.,][p.~11]{vanDijk2001,Ross1987}      =>  e.g., Van Dijk (2001); Ross (1987, p. 11)
    %%  \citeauthor[e.g.,][p.~11]{vanDijk2001,Ross1987}    =>  e.g., van Dijk (2001); Ross (1987, p. 11)
    %%  \Citeauthor[e.g.,][p.~11]{vanDijk2001,Ross1987}    =>  e.g., Van Dijk (2001); Ross (1987, p. 11)
    %%  \citeyear[e.g.,][p.~11]{vanDijk2001}             =>  e.g., 2001, p. 11)
    %%  \footcite[e.g.,][p.~11]{vanDijk2001,Ross1987}      =>  e.g., van Dijk, 2001; Ross, 1987, p. 11. [as footnote]
    %%  \footcitetext[e.g.,][p.~11]{vanDijk2001,Ross1987}  =>  e.g., van Dijk, 2001; Ross, 1987, p. 11. [as footnotetext]
    %%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    \@ifundefined{apaSeven@maskauthoridentity}%  BDB
      {%  change masked references to unmasked
        \providecommand\maskcite\cite
        \providecommand\maskCite\Cite
        \providecommand\maskparencite\parencite
        \providecommand\maskParencite\Parencite
        \providecommand\masktextcite\textcite
        \providecommand\maskTextcite\Textcite
        \providecommand\maskciteauthor\citeauthor
        \providecommand\maskCiteauthor\Citeauthor
        \providecommand\maskciteyear\citeyear
        \providecommand\maskfootcite\footcite
        \providecommand\maskfootcitetext\footcitetext
      }{%  mask references to author

        \RequirePackage{substr}  % to allow counting of masked references
        \newcounter{maskedRefs}

        % \maskcite
        \newcommand\maskcite{\@ifnextchar[{\maskcite@@also}{\maskcite@@also[]}}
        \newcommand\maskcite@@also{}
        \def\maskcite@@also[#1]{\@ifnextchar[{\maskcite@@@also[#1]}{\maskcite@@@also[][#1]}}

        \def\maskcite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskCite
        \newcommand\maskCite{\@ifnextchar[{\maskCite@@also}{\maskCite@@also[]}}
        \newcommand\maskCite@@also{}
        \def\maskCite@@also[#1]{\@ifnextchar[{\maskCite@@@also[#1]}{\maskCite@@@also[][#1]}}

        \def\maskCite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskparencite
        \newcommand\maskparencite{\@ifnextchar[{\maskparencite@@also}{\maskparencite@@also[]}}
        \newcommand\maskparencite@@also{}
        \def\maskparencite@@also[#1]{\@ifnextchar[{\maskparencite@@@also[#1]}{\maskparencite@@@also[][#1]}}

        \def\maskparencite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskParencite
        \newcommand\maskParencite{\@ifnextchar[{\maskParencite@@also}{\maskParencite@@also[]}}
        \newcommand\maskParencite@@also{}
        \def\maskParencite@@also[#1]{\@ifnextchar[{\maskParencite@@@also[#1]}{\maskParencite@@@also[][#1]}}

        \def\maskParencite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskciteauthor
        \newcommand\maskciteauthor{\@ifnextchar[{\maskciteauthor@@also}{\maskciteauthor@@also[]}}
        \newcommand\maskciteauthor@@also{}
        \def\maskciteauthor@@also[#1]{\@ifnextchar[{\maskciteauthor@@@also[#1]}{\maskciteauthor@@@also[][#1]}}

        \def\maskciteauthor@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskCiteauthor
        \newcommand\maskCiteauthor{\@ifnextchar[{\maskCiteauthor@@also}{\maskCiteauthor@@also[]}}
        \newcommand\maskCiteauthor@@also{}
        \def\maskCiteauthor@@also[#1]{\@ifnextchar[{\maskCiteauthor@@@also[#1]}{\maskCiteauthor@@@also[][#1]}}

        \def\maskCiteauthor@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskciteyear
        \newcommand\maskciteyear{\@ifnextchar[{\maskciteyear@@also}{\maskciteyear@@also[]}}
        \newcommand\maskciteyear@@also{}
        \def\maskciteyear@@also[#1]{\@ifnextchar[{\maskciteyear@@@also[#1]}{\maskciteyear@@@also[][#1]}}

        \def\maskciteyear@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskfootcite
        \newcommand\maskfootcite{\@ifnextchar[{\maskfootcite@@also}{\maskfootcite@@also[]}}
        \newcommand\maskfootcite@@also{}
        \def\maskfootcite@@also[#1]{\@ifnextchar[{\maskfootcite@@@also[#1]}{\maskfootcite@@@also[][#1]}}

        \def\maskfootcite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskfootcitetext
        \newcommand\maskfootcitetext{\@ifnextchar[{\maskfootcitetext@@also}{\maskfootcitetext@@also[]}}
        \newcommand\maskfootcitetext@@also{}
        \def\maskfootcitetext@@also[#1]{\@ifnextchar[{\maskfootcitetext@@@also[#1]}{\maskfootcitetext@@@also[][#1]}}

        \def\maskfootcitetext@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \masktextcite
        \newcommand\masktextcite{\@ifnextchar[{\masktextcite@@also}{\masktextcite@@also[]}}
        \newcommand\masktextcite@@also{}
        \def\masktextcite@@also[#1]{\@ifnextchar[{\masktextcite@@@also[#1]}{\masktextcite@@@also[][#1]}}

        \def\masktextcite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

        % \maskTextcite
        \newcommand\maskTextcite{\@ifnextchar[{\maskTextcite@@also}{\maskTextcite@@also[]}}
        \newcommand\maskTextcite@@also{}
        \def\maskTextcite@@also[#1]{\@ifnextchar[{\maskTextcite@@@also[#1]}{\maskTextcite@@@also[][#1]}}

        \def\maskTextcite@@@also%
            [#1][#2]#3{%
                \setcounter{maskedRefs}{0}%
                \SubStringsToCounter{maskedRefs}{,}{#3}%
                \addtocounter{maskedRefs}{1}%
                \ifnum\value{maskedRefs} = 1%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citation removed for masked review})}%
                \else%
                \def\apaSeven@masked@refs{(\textit{\themaskedRefs\ citations removed for masked review})}%
                \fi%
                \apaSeven@masked@refs%
        }

      }

}

%========== APA Section spacing

\newskip\b@level@one@skip   \b@level@one@skip=2.5ex plus 1ex minus .2ex
\newskip\e@level@one@skip   \e@level@one@skip=1.5ex plus .6ex minus .1ex
\newskip\b@level@two@skip   \b@level@two@skip=2.5ex plus 1ex minus .2ex
\newskip\e@level@two@skip   \e@level@two@skip=1.5ex plus .6ex minus .1ex
\newskip\b@level@three@skip \b@level@three@skip=2.0ex plus .8ex minus .2ex
\newskip\e@level@three@skip \e@level@three@skip=1.5ex plus .6ex minus .1ex
\newskip\b@level@four@skip  \b@level@four@skip=0\baselineskip \@plus 0.2ex \@minus 0.2ex
\newskip\e@level@four@skip  \e@level@four@skip=-0.5em
\newskip\b@level@five@skip  \b@level@five@skip=0\baselineskip \@plus 0.2ex \@minus 0.2ex
\newskip\e@level@five@skip  \e@level@five@skip=-0.5em

\ifapamodethesis{%
    \b@level@one@skip=0.2\baselineskip \@plus 0.2ex \@minus 0.2ex
    \e@level@one@skip=0.2\baselineskip \@plus .2ex
    \b@level@two@skip=0.2\baselineskip \@plus 0.2ex \@minus 0.2ex
    \e@level@two@skip=0.2\baselineskip \@plus 0.2ex
    \b@level@three@skip=0.2\baselineskip \@plus 0.2ex \@minus 0.2ex
    \e@level@three@skip=0.2\baselineskip \@plus 0.2ex
    \b@level@four@skip=0\baselineskip \@plus 0.2ex \@minus 0.2ex
    \e@level@four@skip=-0.5em
    \b@level@five@skip=0\baselineskip \@plus 0.2ex \@minus 0.2ex
    \e@level@five@skip=-0.5em
}{}


%========== APA Section heading & seriation, adapted from class apa6e

\setcounter{secnumdepth}{3} % set to 0 to disable section numbering

\RequirePackage{titlesec}

\titleformat{\chapter}[display]
  {\centering\normalfont\large\bfseries}{Chapter \thechapter}{1em}{\centering\Large}

% \renewcommand{\chapter}{\@startsection{chapter}{1}{\z@}%
%     {\b@level@one@skip}{\e@level@one@skip}%
%     {\centering\normalfont\large\bfseries}}

\renewcommand{\section}{\@startsection {section}{1}{\z@}%
    {\b@level@one@skip}{\e@level@one@skip}%
    {\centering\normalfont\normalsize\bfseries}}

\renewcommand{\subsection}{\@startsection{subsection}{2}{\z@}%
    {\b@level@two@skip}{\e@level@two@skip}%
    {\normalfont\normalsize\bfseries}}

\newcommand*{\typesectitle}[1]{#1\addperi}

\newcommand*{\addperi}{%
  \relax\ifhmode%
    \ifnum\spacefactor>\@m \else.\fi%
  \fi%
}

\renewcommand{\subsubsection}{\@startsection{subsubsection}{3}{\z@}%
    {\b@level@three@skip}{\e@level@three@skip}%
    {\normalfont\normalsize\bfseries\itshape}}

\renewcommand{\paragraph}{\@startsection{paragraph}{4}{\parindent}%
    {\b@level@four@skip}%
    {\e@level@four@skip}%
    {\normalfont\normalsize\bfseries\typesectitle}}

\renewcommand{\subparagraph}[1]{\@startsection{subparagraph}{5}{1em}%
    {\b@level@five@skip}%
    {\e@level@five@skip}%
    {\normalfont\normalsize\bfseries\itshape\hspace{\parindent}{#1}\textit{\addperi}}{\relax}}

\AtBeginDocument{\def\st@rtbibsection{\mspart{\refname}}}%  BDB -- this is for apacite
\AtBeginDocument{\def\bibsection{\mspart{\refname}}}%  BDB -- this is for apacite + natbib
\newcommand{\mspart}{{\ifapamodethesis{\clearpage}{}}\@startsection {section}{1}{\z@}%
    {\b@level@one@skip}{\e@level@one@skip}%
    {\centering\normalfont\normalsize}}

\RequirePackage[singlelinecheck=off]{caption}

\ifapamode{% thesis
   \DeclareCaptionLabelFormat{tablelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionLabelFormat{figurelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionTextFormat{tabletext}{\hspace{-\parindent}\raggedright\textit{#1}}
    \DeclareCaptionLabelSeparator{apalabelsep}{\\}
}{% jou
    \DeclareCaptionLabelFormat{tablelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionLabelFormat{figurelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionTextFormat{tabletext}{\hspace{-\parindent}\textit{#1}}
    \DeclareCaptionLabelSeparator{apalabelsep}{\\[\baselineskip]}
}{% doc
    \DeclareCaptionLabelFormat{tablelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionLabelFormat{figurelabel}{\hspace{-\parindent}\raggedright\textbf{#1 #2}}
    \DeclareCaptionTextFormat{tabletext}{\hspace{-\parindent}\raggedright\textit{#1}}
    \DeclareCaptionLabelSeparator{apalabelsep}{\\[\baselineskip]}
}
\captionsetup[table]{position=above,skip=0pt,labelformat=tablelabel,labelsep=apalabelsep,textformat=tabletext}
\captionsetup[figure]{position=above,skip=0pt,labelformat=figurelabel,labelsep=apalabelsep,textfont=it}



\newcommand{\figurenote}[1]{\par \small \textit{\notelabel.} {#1}}
\newcommand{\tablenote}[1]{\begin{tablenotes}[para,flushleft]
        {\small
            \textit{\notelabel.} {#1}
         }
    \end{tablenotes}}


% Refer to LaTeX book to modify, if you want, spaces before and after of
%  \begin{...} ... \end{...} or spaces between \item-s.\newcounter{APAenum}
\newskip\@text@par@indent
\def\APAenumerate{\@text@par@indent\parindent\setbox0\hbox{1. }%
    \list{\arabic{APAenum}.}{\usecounter{APAenum}
    \labelwidth\z@\labelsep\z@\leftmargin\z@\parsep\z@
    \rightmargin\z@\itemsep\z@\topsep\z@\partopsep\z@
    \itemindent\@text@par@indent\advance\itemindent by\wd0
    \def\makelabel##1{\hss\llap{##1 }}}}
\let\endAPAenumerate=\endlist

\def\seriate{\@bsphack\begingroup%
   \setcounter{APAenum}{0}%
   \def\item{\addtocounter{APAenum}{1}(\alph{APAenum})\space}%
   \ignorespaces}
\def\endseriate{\endgroup\@esphack}

\def\APAitemize{\@text@par@indent\parindent\setbox0\hbox{$\bullet$}%
    \list{$\bullet$}{%
    \labelwidth\z@\labelsep.5em\leftmargin\z@\parsep\z@
    \rightmargin\z@\itemsep\z@\topsep\z@\partopsep\z@
    \itemindent\@text@par@indent
    \advance\itemindent by\wd0\advance\itemindent by.5em
    \def\makelabel##1{\hss\llap{##1}}}}
\let\endAPAitemize=\endlist

% \let\enumerate=\APAenumerate
% \let\endenumerate=\endAPAenumerate
% \let\itemize=\APAitemize
% \let\enditemize=\endAPAitemize


%===== apa.cls main declarations for title page contents =====

\long\def\title#1{\long\def\@title{#1}}
\long\def\author#1{\authorsnames{#1}}
\long\def\affiliation#1{\ClassWarning{ala7}{Deprecated: see documentation for \string\authorsaffiliations}\authorsaffiliations{#1}}
\long\def\twoauthors#1#2{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\threeauthors#1#2#3{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\onetwoauthors#1#2#3{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\twooneauthors#1#2#3{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\fourauthors#1#2#3#4{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\fiveauthors#1#2#3#4#5{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\sixauthors#1#2#3#4#5#6{\ClassError{ala7}{Deprecated: see documentation for \string\authorsnames}{For multiple authors use \string\authorsnames}}
\long\def\twoaffiliations#1#2{\ClassError{ala7}{Deprecated: see documentation for \string\authorsaffiliations}{For multiple affiliations use \string\authorsaffiliations}}
\long\def\threeaffiliations#1#2#3{\ClassError{ala7}{Deprecated: see documentation for \string\authorsaffiliations}{For multiple affiliations use \string\authorsaffiliations}}
\long\def\fouraffiliations#1#2#3#4{\ClassError{ala7}{Deprecated: see documentation for \string\authorsaffiliations}{For multiple affiliations use \string\authorsaffiliations}}
\long\def\fiveaffiliations#1#2#3#4#5{\ClassError{ala7}{Deprecated: see documentation for \string\authorsaffiliations}{For multiple affiliations use \string\authorsaffiliations}}
\long\def\sixaffiliations#1#2#3#4#5#6{\ClassError{ala7}{Deprecated: see documentation for \string\authorsaffiliations}{For multiple affiliations use \string\authorsaffiliations}}
\long\def\course#1{\long\def\@course{#1}}
\long\def\professor#1{\long\def\@professor{#1}}
\long\def\duedate#1{\long\def\@duedate{#1}}
\long\def\shorttitle#1{\long\def\@shorttitle{#1}}
\long\def\note#1{\long\def\@note{#1}}
\long\def\abstract#1{\long\def\@abstract{#1}}
\long\def\keywords#1{\long\def\@keywords{#1}}
\long\def\authornote#1{\long\def\@acks{#1}}
\def\journal#1{\def\@journal{#1}}
\def\volume#1{\def\@vvolume{#1}}
\def\ccoppy#1{\def\@ccoppy{#1}}
\def\copnum#1{\def\@copnum{#1}}

% Combined code from https://tex.stackexchange.com/questions/297507/how-to-apply-a-do-function-to-two-lists and 
% https://www.dickimaw-books.com/latex/admin/html/exercises/oxfordcomma.shtml

% Create etoolbox lists for multiple authors and affiliations
\newcommand*\listauthors{}
\newcommand*\listsuperscripts{}
\newcommand*\listaffiliations{}

\newcommand*{\authorsnames}[2][]{
  \def\def@multipleauthors{\@multipleauthorsmode} %
  \renewcommand*\listauthors{}
  \renewcommand*\listsuperscripts{}
  \newcounter{NumberOfAuthors}
  \newcounter{NumberOfSuperscripts}
  \forcsvlist{\stepcounter{NumberOfAuthors}\listadd\listauthors}{#2}
  \forcsvlist{\stepcounter{NumberOfSuperscripts}\listadd\listsuperscripts}{#1}
  }

  \newcommand*{\authorsaffiliations}[1]{
  \def\def@multipleaffils{\@multipleaffilsmode} %
  \renewcommand*\listaffiliations{}
  \newcounter{NumberOfAffiliations}
  \forcsvlist{\stepcounter{NumberOfAffiliations}\listadd\listaffiliations}{#1}
  }

\makeatletter
  \catcode`\|=3

\def\looptwo#1#2{%
    \edef\tmp{\noexpand\xtwo%
      \unexpanded\expandafter{#1}\relax  % no added delimiter here
      \unexpanded\expandafter{#2}\relax  % no added delimiter here
    } \tmp%
  }%

\def\xtwo#1|#2\relax#3|#4\relax{%
    \dotwo{#1}{#3}%
    \def\tmp{#2}%
    \ifx\empty\tmp%
      \expandafter\@gobble%
    \else%
      \expandafter\@firstofone%
    \fi%
    {\xtwo#2\relax#4\relax}%
  }%

  \catcode`\|=12
\makeatother

\newcommand*{\dotwo}[2]{}

\newcommand*{\authorsep}{}%
\newcommand*{\lastauthor}{}%
\newcommand*{\prelastauthor}{}%
\newcommand*{\prelastauthorsep}{}%

\newcommand{\displayauthors}{%
  \renewcommand*{\authorsep}{}%
  \renewcommand*{\lastauthor}{}%
  \renewcommand*{\prelastauthor}{}%
  \renewcommand*{\prelastauthorsep}{}%
  \ifnum\value{NumberOfSuperscripts}=0% If no superscripts are specified, print authors without superscripts.
\renewcommand*{\do}[1]{%
      \authorsep%
    \lastauthor%
    \renewcommand{\lastauthor}{%
      \renewcommand{\authorsep}{,
        \renewcommand*{\prelastauthorsep}{,}}%
      \renewcommand{\prelastauthor}{\prelastauthorsep\ \lastauthorseparator\ }% Terminated commands with \ to preserve following space
      ##1%
    }%
      }%
    \dolistloop{\listauthors}%
  \else
    \renewcommand*{\dotwo}[2]{%
    \authorsep%
    \lastauthor%
    \renewcommand{\lastauthor}{%
      \renewcommand{\authorsep}{,
        \renewcommand*{\prelastauthorsep}{,}}%
      \renewcommand{\prelastauthor}{\prelastauthorsep\ \lastauthorseparator\ }% Terminated commands with \ to preserve following space
      ##1\textsuperscript{##2}%
    }%
  }%
  \looptwo\listauthors\listsuperscripts%
  \fi
  \prelastauthor \lastauthor%
}

\newcommand{\displayaffiliations}{%
  \ifnum\value{NumberOfSuperscripts}=0% If no superscripts are specified, print affiliations without superscripts.
  \renewcommand*{\do}[1]{%
      ##1\\%
  }%
  \else
  \newcounter{AffiliationNumber}
  \renewcommand*{\do}[1]{%
      \stepcounter{AffiliationNumber}
      \textsuperscript{\arabic{AffiliationNumber}}##1\\%
  }%
  \fi
  \dolistloop{\listaffiliations}%
}

\makeatletter

\def\check@author{%
 \@ifundefined{def@multipleauthors}{%
  \ClassWarningNoLine{ala7}{Author not defined}\authorsnames{Author}}{}
 \@ifundefined{@title}{%
  \ClassWarningNoLine{ala7}{Title not defined}\def\@title{Title}}{}
 \@ifundefined{def@multipleaffils}{%
  \ClassWarningNoLine{ala7}{Affiliation not defined}\authorsaffiliations{Affiliation}}{}
   \@ifundefined{def@stu}{% thesis mode
    \@ifundefined{@shorttitle}{%
   \ClassWarningNoLine{ala7}{Short title not defined}\def\@shorttitle{INSERT SHORTTITLE COMMAND IN PREAMBLE}}{}
  \@ifundefined{@abstract}{%
   \ClassWarningNoLine{ala7}{Abstract not defined}}{}
  \@ifundefined{@keywords}{%
   \ClassInfo{ala7}{Keywords not defined}}{}
 }{ % stu mode
 \@ifundefined{@course}{%
   \ClassWarningNoLine{ala7}{Course title not defined}\def\@course{Course Title}}{}
  \@ifundefined{@professor}{%
   \ClassWarningNoLine{ala7}{Professor not defined}\def\@professor{Professor Name}}{}
  \@ifundefined{@duedate}{%
   \ClassWarningNoLine{ala7}{Due date not defined}\def\@duedate{Due Date}}{}
 \@ifundefined{@shorttitle}{%
         \def\@shorttitle{}}{}%
 }
 \@ifundefined{def@multipleauthors}{}{%
   \ifnum\value{NumberOfSuperscripts}=0%
    % do nothing. If no superscripts are specified, print authors and affiliations without superscripts.
   \else \ifnum\value{NumberOfAuthors}=\value{NumberOfSuperscripts}%
         % do nothing
         \else
        \ClassError{ala7}{Number of Authors does not match number of Superscripts}{Please provide an equal number of authors and superscripts.}
 \fi
   \fi
          }%
}

%==== Automatic figure size and orientation determination ====

\newsavebox\gr@box
\newlength\gr@boxwidth
\newlength\gr@boxheight

\newcommand{\fitfigure}[2][0.5]{%
\sbox\gr@box{\includegraphics[width=\linewidth]{#2}}
\settoheight{\gr@boxheight}{\usebox\gr@box}
\ifdim\gr@boxheight>\textheight%
 \centerline{\includegraphics[height=#1\textheight]{#2}}% need to leave space for caption
\else%
 \usebox\gr@box%
\fi
}

\newcommand{\fitbitmap}[2][0.5]{ % like fitfigure but no scaling in thesis mode for best quality
\sbox\gr@box{\includegraphics[width=\linewidth]{#2}}
\settoheight{\gr@boxheight}{\usebox\gr@box}
\ifdim\gr@boxheight>\textheight%
 \centerline{\includegraphics[height=#1\textheight]{#2}}% need to leave space for caption
\else%
 \centerline{\usebox\gr@box}%
\fi
}

%==== Miscellaneous definitions

\let\normal@BBAB\BBAB                        % -- thp 2005/07/23
\let\table@BBAB\BBAA                         % -- thp 2005/07/23

\setlength{\doublerulesep}{\arrayrulewidth}
\newcommand\thickline{\hline\hline}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule height0.125pt width.5in
  \kern2.6\p@}

\let\apaSeventabular\tabular
\let\apaSeven@doc@tabular\tabular
%%
\let\apaSeven@doc@endtabular\endtabular

\def\@tab@fn#1{\ensuremath{^{\mbox{{\scriptsize #1}}}}}
\def\tabfnm#1{\rlap{\@tab@fn{#1}}}
\def\tabfnt#1#2{\raggedright\@tab@fn{#1}#2}

\def\apaSevenvector#1{{\ensuremath
  \uprightlowercasegreek
  \ifapamodethesis
  {\apaSevensmash{\mathop{\kern\z@\mathrm{#1}}\limits_{\scriptscriptstyle\sim}}}%
  {\if@bm@loaded\bm{\mathrm{#1}}\else\mathbf{#1}\fi% in case bm is not available
  }%
}}
\newcommand{\apaSevensmash}{%
  \def\finsm@sh{\dp\z@\z@ \box\z@}%
  \expandafter\mathpalette\expandafter\mathsm@sh
}%
\newif\if@bm@loaded\@bm@loadedfalse
\IfFileExists{bm.sty}{\RequirePackage{bm}\@bm@loadedtrue}{}% if not, apaSevenvector will fail
\newcommand{\uprightlowercasegreek}{%
  \@ifundefined{alphaup}{}{%
    \def\alpha     {\alphaup     }%
    \def\beta      {\betaup      }%
    \def\gamma     {\gammaup     }%
    \def\delta     {\deltaup     }%
    \def\epsilon   {\epsilonup   }%
    \def\varepsilon{\varepsilonup}%
    \def\zeta      {\zetaup      }%
    \def\eta       {\etaup       }%
    \def\theta     {\thetaup     }%
    \def\vartheta  {\varthetaup  }%
    \def\iota      {\iotaup      }%
    \def\kappa     {\kappaup     }%
    \def\lambda    {\lambdaup    }%
    \def\mu        {\muup        }%
    \def\nu        {\nuup        }%
    \def\xi        {\xiup        }%
    \def\pi        {\piup        }%
    \def\varpi     {\varpiup     }%
    \def\rho       {\rhoup       }%
    \def\varrho    {\varrhoup    }%
    \def\sigma     {\sigmaup     }%
    \def\varsigma  {\varsigmaup  }%
    \def\tau       {\tauup       }%
    \def\upsilon   {\upsilonup   }%
    \def\phi       {\phiup       }%
    \def\varphi    {\varphiup    }%
    \def\chi       {\chiup       }%
    \def\psi       {\psiup       }%
    \def\omega     {\omegaup     }%
  }%
}
\let\apaSevenmatrix\apaSevenvector

%==== Appendix macros added by Michael Erickson 2000/07/11, revised by thp 2000/07/18

% Define a new counter called `appendix` and set its initial value to 0
\newcounter{appendix}\setcounter{appendix}{0}

% Redefine the format of the appendix counter to use uppercase letters
\renewcommand{\theappendix}{\@Alph\c@appendix}

% Define macros to redefine the format of the figure, table, and equation counters to include the appendix counter
\def\apaSevenappfig{%
 \renewcommand\thefigure{\theappendix\@arabic\c@figure}%
 \ifapamodethesis{\renewcommand\thepostfig{\theappendix\arabic{postfig}}}{}}
\def\apaSevenapptab{%
 \renewcommand\thetable{\theappendix\@arabic\c@table}%
 \ifapamodethesis{\renewcommand\theposttbl{\theappendix\arabic{posttbl}}}{}}
\def\apaSevenappeq{%
 \renewcommand\theequation{\theappendix\@arabic\c@equation}}

% Define a new flag called `oneappendix` and set it to true by default
\newif\ifoneappendix
\oneappendixtrue % one appendix by default

% Define a new flag called `appendix` and set it to false by default
\newif\ifappendix
\appendixfalse

% Define the behavior of the appendix section
\def\appendix{%
  % Output all tables and figures prior to the appendix
  \ifapamodethesis{\processdelayedfloats}{}%
  % Set the `appendix` flag to true
  \appendixtrue
  % Redefine the format of the figure, table, and equation counters to include the appendix counter
  \apaSevenappfig
  \apaSevenapptab
  \apaSevenappeq
  % Redefine the behavior of the `section` macro to include the appendix counter in the section title
  \let\old@apaSeven@section=\section
  \long\def\section##1{%
                   \makeatletter%
                     \def\@currentlabelname{##1}%
                   \makeatother%
                   % Output all tables and figures prior to the appendix
                   \ifapamodethesis{%
                    \clearpage
                    \setcounter{postfig}{0}
                    \setcounter{posttbl}{0}
                   }{%
                   }%
                    % Reset the figure, table, and equation counters to 0
                    \setcounter{figure}{0}%
                    \setcounter{table}{0}%
                    \setcounter{equation}{0}%
                    % Add the appendix counter to the section title
                    \vskip2.5ex%
                   \refstepcounter{appendix}% 2002/07/20 this takes care of references too
                   % Set the `oneappendix` flag to false if there is more than one appendix section
                   \ifnum\c@appendix>1\immediate\write\@auxout{\global\string\oneappendixfalse}\fi%
                      \centerline{\normalfont\normalsize\textbf\appendixname\ifoneappendix\else~\textbf\theappendix\fi}%
                      \centerline{\normalfont\normalsize\bfseries##1}\par%
                      \setlength{\parindent}{0.5in}
                      \makeatletter%
                        \@afterindentfalse%
                        \@afterheading%
                      \makeatother%
                  }%
} % end of appendix definition


%%%%%%%%%%%%%%%%%%%%%%%%%
%%                     %%
%%    THESIS  FORMAT   %%
%%                     %%
%%%%%%%%%%%%%%%%%%%%%%%%%

\@ifundefined{def@thesis}{}{%

  \def\@@spacing{1.655}

  % allow a little more space between captions and floats in man mode
  \newcommand{\@doublespacing}{\linespread{1.655}}
  \@doublespacing

  \captionsetup[table]{skip=10pt}
  \captionsetup[figure]{skip=10pt}

  \def\rightheader#1{\def\r@headr{\protect\MakeUppercase{#1}}}
  \def\leftheader#1{\def\r@headl{#1}}

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\newcommand{\shorttitle}[1]{\def\@shorttitle{#1}}

  \raggedright

  \RequirePackage{fancyhdr}
  \setlength{\headheight}{15.2pt}
  \fancyhf{}
  \renewcommand{\headrulewidth}{0pt}

  \fancypagestyle{titlepage}{%
      \lhead{\MakeUppercase{\@shorttitle}}%
      \rhead{\thepage}%
  }
  \fancypagestyle{otherpage}{%
      \lhead{\MakeUppercase{\@shorttitle}}%
      \rhead{\thepage}%
  }
  \pagestyle{otherpage}

  %========== Alterations to endnotes ===================

  %% added by BDB to make section heading non-bolface
  %% \@ifundefined{@acks}{}{\newpage\section{\acksname}\@acks}

  %========= Alterations to endfloat ====================

  % prepare to bypass endfloat for any tables or figures in appendices
  \let\@noendfloattab\table% BDB
  \let\@noendfloatfig\figure% BDB


  \RequirePackage[notablist,figlist,notabhead,nofighead,tablesfirst,nomarkers]{endfloat}[1995/10/11]


  \def\@gobbleuntilnext[#1]{}
  \let\eatarg\@gobbleuntilnext
  \let\ifnextchar\@ifnextchar

  \@ifundefined{def@floatsintext}{%  Guillaume Jourjon 19/10/10
    \def\figure{%
        \ifappendix
            \vspace*{\intextsep}
            \def\fps@figure{!hbt}%
            \@noendfloatfig
        \else
            \efloat@condopen{fff}
            \@nameuse{efloat@separator@fff}%
            \efloat@iwrite{fff}{\string\begin{figure*}[hbt]}%
            \global\def\@figure@written{\relax}% Set a flag that there is at least one figure -- thp 20010705
        %% should be a global declaration to be "visible" at end document
            \ifnextchar[{\gobbleuntilnext[}{}
            \efloat@iwrite{fff}{\string\ifnextchar[{\string\eatarg}{}}
            \def\@currenvir{efloat@float}%
            \begingroup%
            \let\do\ef@makeinnocent \dospecials%
            \ef@makeinnocent\^^L% and whatever other special cases
            \endlinechar`\^^M \catcode`\^^M=12 \ef@xfigure%
        \fi%
    }%

    \def\table{%
        \ifappendix
            \vspace*{\intextsep}
            \def\fps@table{!hbt}
            \@noendfloattab
        \else
            \efloat@condopen{ttt}
            \@nameuse{efloat@separator@ttt}%
            \efloat@iwrite{ttt}{\string\begin{table*}[hbt]}%
            \ifnextchar[{\gobbleuntilnext[}{}
            \@ifundefined{hrm}{}{%
            \efloat@iwrite{ttt}{\string\sf}}%
            \efloat@iwrite{ttt}{\string\ifnextchar[{\string\eatarg}{}} % bj
            \def\@currenvir{efloat@float}%
            \begingroup
            \let\do\ef@makeinnocent \dospecials
            \ef@makeinnocent\^^L% and whatever other special cases
            \endlinechar`\^^M \catcode`\^^M=12 \ef@xtable%
        \fi
    }%

  % for rotated tables, per Ulrike Fischer:  http://tex.stackexchange.com/a/79843
  \RequirePackage{etoolbox}
    \AtEndPreamble{%
      \@ifpackageloaded{rotating}{%
        \DeclareDelayedFloatFlavor{sidewaystable}{table}
        \DeclareDelayedFloatFlavor{sidewaysfigure}{figure}
        }{}%
    }%

  }{%
    \RequirePackage{float}
    \floatplacement{figure}{htb}
    \def\figure{\@float{figure}}
    \def\endfigure{\end@float}

    \floatplacement{table}{htb}
    \def\table{\@float{table}}
    \def\endtable{\end@float}
  }

  %%%%%%%%%%%%%%\long\def\@@contentsline#1#2#3{ #2 }
  %%%%%%%%%%%%%%\long\def\numberline#1#2{\noindent{\em\figurename\ #1.\/} #2\vspace{0.5\baselineskip}\par}
  %%%%%%%%%%%%%%\long\def\@@caption{\refstepcounter\@captype \@dblarg{\@@@caption\@captype}}
  %%%%%%%%%%%%%%\long\def\@@@caption#1[#2]#3{\addcontentsline{\csname
  %%%%%%%%%%%%%%  ext@#1\endcsname}{#1}{\protect\numberline{\csname
  %%%%%%%%%%%%%%  the#1\endcsname}{\ignorespaces #2}}}


  \def\processfigures{%
  \expandafter\ifnum \csname @ef@fffopen\endcsname>0
    \immediate\closeout\efloat@postfff \ef@setct{fff}{0}
    \clearpage
    \if@figlist
    \@ifundefined{@figure@written}{}{%
      {\normalsize\@ifundefined{hrm}{}{\sf}%
      }
    }
    \fi
    \@ifundefined{fig@num}{%
    \pagestyle{otherpage}
    }{%
    \setcounter{page}{1}
    \def\@oddhead{\rightmark}                                    % changed by Michael Erickson
    \markright{\hfill \s@title, \figurename\ \protect\thefigure} % to include appendix numbering
                                                                  % remove rm - thp 020227
    }
    \def\baselinestretch{\@@spacing}\normalsize\@ifundefined{hrm}{}{\sf}
    \processfigures@hook \@input{\jobname.fff}
  \fi}

  \def\processtables{%
    \expandafter\ifnum \csname @ef@tttopen\endcsname>0
    \immediate\closeout\efloat@postttt \ef@setct{ttt}{0}
    \clearpage
    \if@tabhead
        \section*{\tablesection}
        \suppressfloats[t]
    \fi
    \def\baselinestretch{\@@spacing}
    \processtables@hook \@ifundefined{hrm}{}{\sf}%
    \tiny\normalsize%
    \let\BBAB\table@BBAB%  -- thp 2005/07/23
    \@input{\jobname.ttt}%
    \let\BBAB\normal@BBAB% -- thp 2005/07/23
  \fi}

  %========== Alterations to captions (BDB) ===================

  \captionsetup{justification=raggedright}

  %========= Maketitle, margins, lengths, etc. ==========

  \def\maketitle{
    \@ifundefined{hrm}{}{\hrm}
    \check@author
  
    \begin{center}
  
      \vspace*{4\baselineskip}
      \textbf\@title%
      \ifapamodethesis{%
        \vspace{\baselineskip}\\
      }{%
        \vspace{\baselineskip}\\
      }
  

      \@ifundefined{apaseven@maskauthoridentity}
      {%  bdb
        \displayauthors \\
        \displayaffiliations
        \@ifundefined{@note}
        {\vspace*{\baselineskip} }
        {\@note}
      }{%  mask author identity -- show nothing in the author or author note space
      }

    \end{center}

    \@ifundefined{apaseven@maskauthoridentity}
    {
      \@ifundefined{@acks}
      {}
      {%
        \vfill%
        \section*{\normalfont\normalsize\textbf\acksname}
        \raggedright
        \setlength{\parindent}{0.5in}
        \indent\@acks\par%
      }
    }
    {%  mask author identity -- show nothing in the author or author note space
    }
  
    \newpage
    %bdb\hyphenpenalty 10000
    \fussy
    \@ifundefined{@abstract}{}{%
      \section*{\normalfont\normalsize\textbf\abstractname}% bdb
      \noindent\@abstract\par% bdb
      \@ifundefined{@keywords}{}{%
        \setlength{\parindent}{0.5in}% bdb
        \indent\textit{\keywordname:} \@keywords%
      }%
      \newpage
    }

    \@ifundefined{def@donotrepeattitle}{
      \section*{\protect\normalfont\textbf{\@title}}
    }{}%
    \raggedright%
    \setlength{\parindent}{0.5in}%
  }

  \thispagestyle{titlepage}


  \setlength{\footnotesep}{16pt}

  \renewcommand\@makefntext[1]{\raggedright\textsuperscript{\@thefnmark}~#1}


  \newcommand{\footmark}[1]{${}^{\mbox{\normalsize #1}}$}

  %% added second set of braces around \em  to get citations in man mode -- tp 17/7/2000
  %% then removed them again because they were cancelling application of em to the caption

  \setcounter{topnumber}{1}
  \def\topfraction{.7}
  \setcounter{bottomnumber}{1}
  \def\bottomfraction{.6}
  \setcounter{totalnumber}{1}
  \def\textfraction{0}
  \def\floatpagefraction{.7}
  \setcounter{dbltopnumber}{1}
  \def\dbltopfraction{.7}
  \def\dblfloatpagefraction{.7}
  \def\dbltextfloatsep{\textfloatsep}

  \fussy

  \@ifundefined{def@nosf}{%
  \def\helvetica{%
  \ClassWarning{ala7}{ignored \string\helvetica\space (use helv option)}
  }}{\def\helvetica{\relax}}



}% end of thesis mode (manuscript format)


%---------- end of mode specific definitions -----------

% =======================================================
%       Some final definitions for all modes
% =======================================================

\let\ignore\@gobble

\@ifundefined{def@apacite}{}{% -- Philip Kime 2008/12/03
  \bibliographystyle{apacite}
  %
  % Thanks to Donald Arsenau for the right way to ignore \bibliographystyle
  %
  \def\bibliographystyle#1{\ClassWarning{ala7}{\string\bibliographystyle\space
      command ignored}}}

\@ifundefined{def@natbib}{}{% -- Philip Kime 2008/12/03
  \bibliographystyle{apacite}
  %
  % Thanks to Donald Arsenau for the right way to ignore \bibliographystyle
  %
  \def\bibliographystyle#1{\ClassWarning{ala7}{\string\bibliographystyle\space
      command ignored}}}


%% 
%% Copyright (C) 2022 by Daniel A. Weiss <daniel.weiss.led at gmail.com>
%% 
%% This work may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License (LPPL), either
%% version 1.3c of this license or (at your option) any later
%% version.  The latest version of this license is in the file:
%% 
%% http://www.latex-project.org/lppl.txt
%% 
%% Users may freely modify these files without permission, as long as the
%% copyright line and this statement are maintained intact.
%% 
%% This work is not endorsed by, affiliated with, or probably even known
%% by, the American Psychological Association.
%% 
%% This work is "maintained" (as per LPPL maintenance status) by
%% Daniel A. Weiss.
%% 
%% This work consists of the file  apa7.dtx
%% and the derived files           apa7.ins,
%%                                 apa7.cls,
%%                                 apa7.pdf,
%%                                 README,
%%                                 APA7american.txt,
%%                                 APA7british.txt,
%%                                 APA7dutch.txt,
%%                                 APA7english.txt,
%%                                 APA7french.txt,
%%                                 APA7german.txt,
%%                                 APA7ngerman.txt,
%%                                 APA7greek.txt,
%%                                 APA7czech.txt,
%%                                 APA7turkish.txt,
%%                                 APA7spanish.txt,
%%                                 APA7hungarian.txt,
%%                                 APA7endfloat.cfg,
%%                                 Figure1.pdf,
%%                                 shortsample.tex,
%%                                 longsample.tex, and
%%                                 bibliography.bib.
%% 
%%
%% End of file `apa7.cls'.
