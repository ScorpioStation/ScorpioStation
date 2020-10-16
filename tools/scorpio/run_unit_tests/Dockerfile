FROM scorpiostation/byond:latest

ENV LD_LIBRARY_PATH="/byond/bin:${LD_LIBRARY_PATH}"
ENV PATH="/byond/bin:${PATH}"

# Build the Scorpio image for Unit Testing
COPY . /scorpio
COPY --from=scorpiostation/scorpio:latest /scorpio/tgui/packages/tgui/public /scorpio/tgui/packages/tgui/public
WORKDIR /scorpio
RUN DreamMaker ci-scorpio.dme

# Run the Unit Tests
RUN DreamDaemon paradise.dmb -close -trusted -verbose

# Check that the Unit Tests passed
RUN cat data/clean_run.lk
