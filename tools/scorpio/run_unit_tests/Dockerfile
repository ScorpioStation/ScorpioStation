FROM scorpiostation/byond:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssl \
    && rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH="/scorpio:/byond/bin:${LD_LIBRARY_PATH}"
ENV PATH="/byond/bin:${PATH}"

COPY . /scorpio
COPY --from=scorpiostation/scorpio:latest /scorpio/icons/_nanomaps/Emerald_nanomap_z1.png /scorpio/icons/_nanomaps/Emerald_nanomap_z1.png
COPY --from=scorpiostation/scorpio:latest /scorpio/tgui/packages/tgui/public /scorpio/tgui/packages/tgui/public
WORKDIR /scorpio
RUN DreamMaker ci-scorpio.dme

COPY --from=scorpiostation/scorpio:latest /scorpio/librust_g.so /scorpio/librust_g.so
COPY --from=scorpiostation/scorpio:latest /scorpio/libmariadb.so /scorpio/libmariadb.so
RUN DreamDaemon ci-scorpio.dmb -trusted -close -verbose

RUN cat data/clean_run.lk
