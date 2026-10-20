FROM opensuse/leap:16.0
ADD . /root
#RUN zypper dup -y -l
RUN zypper addrepo https://download.opensuse.org/repositories/home:hpcoder1/16.0/home:hpcoder1.repo
RUN zypper --gpg-auto-import-keys refresh
RUN zypper --non-interactive install -y -l git make ccache clang libomp-devel tcl-devel tk-devel libdb-4_8-devel gsl-devel cairo-devel pango-devel readline-devel gdbm-devel libXss-devel unittest++-devel libxml2-devel libtiff-devel libopenssl-devel soci-devel gtest gmock gzip libstdc++6-devel-gcc16
# Boost
RUN zypper --non-interactive install -y -l libboost_headers-devel libboost_thread-devel libboost_date_time-devel libboost_filesystem-devel libboost_program_options-devel libboost_regex-devel libboost_system-devel libboost_python3-devel

# Minsky specific packages here
RUN zypper --non-interactive install -y -l tar librsvg2-devel octave-cli blas-devel firefox xvfb-run xorg-x11-fonts xauth which csvprintf rsvg-convert libclipboard-devel
RUN zypper --non-interactive install -y -l npm nodejs22-devel
RUN npm install -g jest
RUN npm install -g ts-node
RUN npm install -g exitzero
RUN ln -sf /usr/local/lib/node_modules/jest/bin/jest.js /usr/local/bin/jest

# For EcoLab
#RUN zypper --non-interactive install unuran

# SciDAVis specific packages
RUN zypper install -y -l libqt5-qtsvg-devel  libqt5-qtwayland libtirpc-devel muparser-devel python3-devel glu-devel python3-numpy libqt5-linguist-devel

# LaTeX
RUN zypper --non-interactive install -y -l  texlive-collection-latex latex2html texlive-epstopdf-bin texlive-pstricks lyx
# fix texlive bug: https://forums.opensuse.org/showthread.php/528778-mktexfmt-ERROR-user-mode-but-path-setup-is-sys-type-bailing-out
RUN mkdir /run/texlive
RUN touch /var/run/texlive/run-hyphen
RUN touch /var/run/texlive/run-fmtutil.language
RUN touch /var/run/texlive/run-fmtutil.refresh
RUN /usr/share/texmf/texconfig/update

# some additional debugging tools
RUN zypper --non-interactive install -y -l  emacs-nox gdb

# linkchecker
RUN zypper --non-interactive install python313-pip
RUN pip3 install git+https://github.com/linkchecker/linkchecker.git

# unuran (for EcoLab)
#RUN tar zxvf /root/unuran-1.11.0.tar.gz
#RUN (cd unuran-1.11.0; ./configure --enable-shared --libdir=/usr/local/lib64; make install)

# install claude
RUN npm install -g @anthropic-ai/claude-code
ENV CLAUDE_PERMISSION_MODE=bypassPermissions
ENV CLAUDE_PERMISSION_PROMPTS=none
