FROM ubuntu:latest
#
# Build stress tool
#
ENV DEBIAN_FRONTEND=noninteractive
RUN useradd --create-home stress
RUN apt-get update && apt-get -y upgrade
RUN apt-get install -y -o Dpkg::Options::=--force-confdef -o Dpkg::Options::=--force-confnew bash stress

USER stress
WORKDIR /home/stress

ENV STRESS_CPU=1
ENV STRESS_VM=1
ENV STRESS_VM_BYTES=256M
ENV STRESS_TIMEOUT=3600s

ENTRYPOINT ["stress"]
CMD ["--cpu", "${STRESS_CPU}", "--vm", "${STRESS_VM}", "--vm-bytes", "${STRESS_VM_BYTES}", "--timeout", "${STRESS_TIMEOUT}"]
