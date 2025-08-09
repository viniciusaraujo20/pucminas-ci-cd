# CASO NECESSITE INICIAR O JENKINS VIA DOCKER #
# Jenkins CI Demo (POS SRE - CI/CD)

Este pacote sobe um Jenkins com os **plugins necessários** e um `Jenkinsfile` que cobre:
Agent, Variáveis de ambiente, Options, Parameters, Trigger, Post actions,
Steps, Input, Conditions (`when/not/equals`), Credenciais, **Parallel Stages** e **Matrix**.

## Requisitos
- Docker e Docker Compose instalados.

## Subir o Jenkins
```bash
docker compose up -d --build
```
Acesse: http://localhost:8081

### Desbloquear o Jenkins
Pegue a senha inicial (no host):
```bash
docker logs jenkins-sre-demo 2>&1 | grep -m1 'Please use the following password' -A2
```

Siga o wizard, mantenha **Install suggested plugins** (os necessários já estão pré-instalados). Crie o usuário admin.

-----------------------------------------------

# INICIANDO JÁ COM JENKINS INSTALADO #

### Plugins necessários:
```bash
workflow-aggregator
pipeline-model-definition
pipeline-stage-view
credentials-binding
pipeline-input-step
git
ssh-agent
```

## Criar a credencial exigida pelo pipeline
1. *Manage Jenkins - Engranagem* → *Credentials* → *(global)* → *Add Credentials*  
2. Tipo: **Username with password**  
3. **ID**: `meu-usuario-senha` (tem que ser exatamente este)  
4. Username e Password: qualquer valor (ex.: `demo` / `demo123`) - Create

## Criar o pipeline
1. *Nova Tarefa* → **Pipeline** → Nome: `pipeline-sre-demo` → **Tudo Certo**
2. Em **Pipeline** → **Definition**: *Pipeline script*
3. Cole o conteúdo do `Jenkinsfile` deste pacote e salve.
4. Clique em **Construir agora**.
   - O pipeline vai pedir **Input** de confirmação.
   - Clique em **Proceed** para prosseguir.
   - Possui `triggers { cron('H/15 * * * *') }` (agendamento a cada ~15 min).
## ⏱️ Trigger (cron)
- `H/15 * * * *` → a cada 15 minutos a partir do minuto **H** do job.
   - Tem `when { not { equals ... } }` no stage **Build**.
   - Usa credenciais no stage **Credenciais**.
   - Tem **parallel** e **matrix**.

-----------------------------------------------

## Arquivos incluídos
- `docker-compose.yml` — sobe o Jenkins
- `Dockerfile` — instala plugins automaticamente
- `plugins.txt` — lista de plugins
- `Jenkinsfile` — pipeline completo do trabalho

## Plugins instalados
- workflow-aggregator
- pipeline-model-definition
- pipeline-stage-view
- credentials-binding
- pipeline-input-step
- git
- ssh-agent

## 🧩 Jenkinsfile — mapa dos requisitos
- **Agent** → `agent any`
- **Variáveis de ambiente** → `environment { APP_NAME, VERSION, DEPLOY_ENV }`
- **Options** → `options { timeout, buildDiscarder, timestamps }`
- **Parameters** → `parameters { AMBIENTE, EXECUTAR_TESTES, LINGUAGEM }`
- **Trigger** → `triggers { cron('H/15 * * * *') }`
- **Post actions** → `post { always, success, failure }`
- **Steps** → blocos `steps { ... }` (echo, sleep, withCredentials)
- **Input** → stage **Confirmação do Usuário** com `input`
- **Conditions (when/not/equals)** → stage **Build**; `when { expression { ... } }` no **Testes**
- **Credenciais** → stage **Credenciais** com `withCredentials([usernamePassword(...)])`
- **Parallel Stages** → stage **Execução Paralela** com `parallel { ... }`
- **Matrix** → stage **Matrix de Build** com `matrix { axes { OS, JDK } }`
