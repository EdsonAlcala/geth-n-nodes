FROM edsonalcala/geth:1.1-alpine

RUN mkdir -p /qdata

WORKDIR /qdata

EXPOSE 9001-9004

COPY . .

RUN chmod -R 777 ./

RUN echo -e '#!/bin/bash \n /qdata/start.sh ' > /usr/bin/start-nodes && \
    chmod +x /usr/bin/start-nodes

CMD ["bash"]