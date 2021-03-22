include .env
export

clean:
	microk8s uninstall
	multipass delete microk8s-vm
	multipass purge
	multipass list

install:
	microk8s install --disk 50 --cpu 4 --mem 15
	multipass exec microk8s-vm -- sudo usermod -a -G microk8s ubuntu
	multipass exec microk8s-vm -- sudo microk8s.kubectl get nodes
	multipass exec microk8s-vm -- sudo chown -f -R ubuntu ~/.kube

enable:
	microk8s enable dns storage
	microk8s enable kubeflow

stop:
	microk8s stop

start:
	microk8s start

sh:
	multipass shell microk8s-vm

f:
	docker pull kubeflow/kfctl
	docker run -d --name my-kf -v /d/temp:/data kubeflow/kubeflow-triage
	docker logs -f my-kf

ktool:
	git clone https://github.com/canonical-labs/kubernetes-tools
	sudo kubernetes-tools/setup-microk8s.sh
	# If you have a GPU, run: `microk8s.enable gpu`

	git clone https://github.com/canonical-labs/kubeflow-tools
	kubeflow-tools/install-kubeflow.sh

#https://www.bookstack.cn/read/kubeflow-0.7/a890e2168e081bd6.md#bpwr8e
	multipass launch bionic -n kubeflow -m 8G -d 40G -c 4
	multipass shell kubeflow
	git clone https://github.com/canonical-labs/kubernetes-tools
	sudo kubernetes-tools/setup-microk8s.sh
	git clone https://github.com/canonical-labs/kubeflow-tools
	kubeflow-tools/install-kubeflow.sh
	# Point browser: http://<kubeflow VM IP>:<Ambassador PORT>