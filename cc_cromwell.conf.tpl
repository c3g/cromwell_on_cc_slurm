# This is a "default" Cromwell example that is intended for you you to start with
# and edit for your needs. Specifically, you will be interested to customize
# the configuration based on your preferred backend (see the backends section
# below in the file). For backend-specific examples for you to copy paste here,
# please see the cromwell.backend.examples folder in the repository. The files
# there also include links to online documentation (if it exists)

# This line is required. It pulls in default overrides from the embedded cromwell
# `reference.conf` (in core/src/main/resources) needed for proper performance of cromwell.
include required(classpath("application"))

# Cromwell HTTP server settings
webservice {
  #port = 8000
  #interface = 0.0.0.0
  #binding-timeout = 5s
  #instance.name = "reference"
}

akka {
  # Optionally set / override any akka settings
  http {
    server {
      # Increasing these timeouts allow rest api responses for very large jobs
      # to be returned to the user. When the timeout is reached the server would respond
      # `The server was not able to produce a timely response to your request.`
      # https://gatkforums.broadinstitute.org/wdl/discussion/10209/retrieving-metadata-for-large-workflows
      # request-timeout = 20s
      # idle-timeout = 20s
    }
  }
}

# Cromwell "system" settings
system {
  # If 'true', a SIGINT will trigger Cromwell to attempt to abort all currently running jobs before exiting
  #abort-jobs-on-terminate = false

  # If 'true', a SIGTERM or SIGINT will trigger Cromwell to attempt to gracefully shutdown in server mode,
  # in particular clearing up all queued database writes before letting the JVM shut down.
  # The shutdown is a multi-phase process, each phase having its own configurable timeout. See the Dev Wiki for more details.
  #graceful-server-shutdown = true

  # Cromwell will cap the number of running workflows at N
  #max-concurrent-workflows = 5000

  # Cromwell will launch up to N submitted workflows at a time, regardless of how many open workflow slots exist
  #max-workflow-launch-count = 50

  # Number of seconds between workflow launches
  #new-workflow-poll-rate = 20

  # Since the WorkflowLogCopyRouter is initialized in code, this is the number of workers
  #number-of-workflow-log-copy-workers = 10

  # Default number of cache read workers
  #number-of-cache-read-workers = 25

  io {
    # Global Throttling - This is mostly useful for GCS and can be adjusted to match
    # the quota availble on the GCS API
    #number-of-requests = 100000
    #per = 100 seconds

    # Number of times an I/O operation should be attempted before giving up and failing it.
    #number-of-attempts = 5
  }

  # Maximum number of input file bytes allowed in order to read each type.
  # If exceeded a FileSizeTooBig exception will be thrown.
  input-read-limits {

    #lines = 128000

    #bool = 7

    #int = 19

    #float = 50

    #string = 128000

    #json = 128000

    #tsv = 128000

    #map = 128000

    #object = 128000
  }

  abort {
    # These are the default values in Cromwell, in most circumstances there should not be a need to change them.

    # How frequently Cromwell should scan for aborts.
    scan-frequency: 30 seconds

    # The cache of in-progress aborts. Cromwell will add entries to this cache once a WorkflowActor has been messaged to abort.
    # If on the next scan an 'Aborting' status is found for a workflow that has an entry in this cache, Cromwell will not ask
    # the associated WorkflowActor to abort again.
    cache {
      enabled: true
      # Guava cache concurrency.
      concurrency: 1
      # How long entries in the cache should live from the time they are added to the cache.
      ttl: 20 minutes
      # Maximum number of entries in the cache.
      size: 100000
    }
  }

  # Cromwell reads this value into the JVM's `networkaddress.cache.ttl` setting to control DNS cache expiration
  dns-cache-ttl: 3 minutes
}

workflow-options {
  # These workflow options will be encrypted when stored in the database
  #encrypted-fields: []

  # AES-256 key to use to encrypt the values in `encrypted-fields`
  #base64-encryption-key: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="

  # Directory where to write per workflow logs
  #workflow-log-dir: "cromwell-workflow-logs"

  # When true, per workflow logs will be deleted after copying
  #workflow-log-temporary: true

  # Workflow-failure-mode determines what happens to other calls when a call fails. Can be either ContinueWhilePossible or NoNewCalls.
  # Can also be overridden in workflow options. Defaults to NoNewCalls. Uncomment to change:
  workflow-failure-mode: "ContinueWhilePossible"

  default {
    # When a workflow type is not provided on workflow submission, this specifies the default type.
    #workflow-type: WDL

    # When a workflow type version is not provided on workflow submission, this specifies the default type version.
    #workflow-type-version: "draft-2"

    # To set a default hog group rather than defaulting to workflow ID:
    #hogGroup: "static"
  }
}

# Optional call-caching configuration.
call-caching {
  # Allows re-use of existing results for jobs you've already run
  # (default: false)
  enabled = true

  # Whether to invalidate a cache result forever if we cannot reuse them. Disable this if you expect some cache copies
  # to fail for external reasons which should not invalidate the cache (e.g. auth differences between users):
  # (default: true)
  invalidate-bad-cache-results = true

  # The maximum number of times Cromwell will attempt to copy cache hits before giving up and running the job.
  #max-failed-copy-attempts = 1000000

  # blacklist-cache {
  #   # The call caching blacklist cache is off by default. This cache is used to blacklist cache hits based on cache
  #   # hit ids or buckets of cache hit paths that Cromwell has previously failed to copy for permissions reasons.
  #   enabled: true
  #
  #   # A blacklist grouping can be specified in workflow options which will inform the blacklister which workflows
  #   # should share a blacklist cache.
  #   groupings {
  #     workflow-option: call-cache-blacklist-group
  #     concurrency: 10000
  #     ttl: 2 hours
  #     size: 1000
  #   }
  #
  #   buckets {
  #     # Guava cache concurrency.
  #     concurrency: 10000
  #     # How long entries in the cache should live from the time of their last access.
  #     ttl: 20 minutes
  #     # Maximum number of entries in the cache.
  #     size: 1000
  #   }
  #
  #   hits {
  #     # Guava cache concurrency.
  #     concurrency: 10000
  #     # How long entries in the cache should live from the time of their last access.
  #     ttl: 20 minutes
  #     # Maximum number of entries in the cache.
  #     size: 100000
  #   }
  #
  # }
}

# Google configuration
google {

  #application-name = "cromwell"

  # Default: just application default
  #auths = [

    # Application default
    #{
    #  name = "application-default"
    #  scheme = "application_default"
    #},

    # Use a refresh token
    #{
    #  name = "user-via-refresh"
    #  scheme = "refresh_token"
    #  client-id = "secret_id"
    #  client-secret = "secret_secret"
    #},


    # Use a static service account
    #{
    #  name = "service-account"
    #  scheme = "service_account"
    #  Choose between PEM file and JSON file as a credential format. They're mutually exclusive.
    #  PEM format:
    #  service-account-id = "my-service-account"
    #  pem-file = "/path/to/file.pem"
    #  JSON format:
    #  json-file = "/path/to/file.json"
    #}

    # Use service accounts provided through workflow options
    #{
    #   name = "user-service-account"
    #   scheme = "user_service_account"
    #}
  #]
}

docker {
  hash-lookup {
    # Set this to match your available quota against the Google Container Engine API
    #gcr-api-queries-per-100-seconds = 1000

    # Time in minutes before an entry expires from the docker hashes cache and needs to be fetched again
    #cache-entry-ttl = "20 minutes"

    # Maximum number of elements to be kept in the cache. If the limit is reached, old elements will be removed from the cache
    #cache-size = 200

    # How should docker hashes be looked up. Possible values are "local" and "remote"
    # "local": Lookup hashes on the local docker daemon using the cli
    # "remote": Lookup hashes on docker hub and gcr
    #method = "remote"
  }
}

engine {
  # This instructs the engine which filesystems are at its disposal to perform any IO operation that it might need.
  # For instance, WDL variables declared at the Workflow level will be evaluated using the filesystems declared here.
  # If you intend to be able to run workflows with this kind of declarations:
  # workflow {
  #    String str = read_string("gs://bucket/my-file.txt")
  # }
  # You will need to provide the engine with a gcs filesystem
  # Note that the default filesystem (local) is always available.
  filesystems {
    #  gcs {
    #    auth = "application-default"
    #    # Google project which will be billed for the requests
    #    project = "google-billing-project"
    #  }
    #  oss {
    #    auth {
    #      endpoint = ""
    #      access-id = ""
    #      access-key = ""
    #      security-token = ""
    #    }
    #  }
    local {
      #enabled: true
    }
  }
}

# You probably don't want to override the language factories here, but the strict-validation and enabled fields might be of interest:
#
# `enabled`: Defaults to `true`. Set to `false` to disallow workflows of this language/version from being run.
# `strict-validation`: Specifies whether workflows fail if the inputs JSON (or YAML) file contains values which the workflow did not ask for (and will therefore have no effect).
languages {
  WDL {
    versions {
      "draft-2" {
        # language-factory = "languages.wdl.draft2.WdlDraft2LanguageFactory"
        # config {
        #   strict-validation: true
        #   enabled: true
        #   caching {
        #     # WDL Draft 2 namespace caching is off by default, this value must be set to true to enable it.
        #     enabled: false
        #     # Guava cache concurrency
        #     concurrency: 2
        #     # How long entries in the cache should live from the time of their last access.
        #     ttl: 20 minutes
        #     # Maximum number of entries in the cache (i.e. the number of workflow source + imports => namespace entries).
        #     size: 1000
        #   }
        # }
      }
      # draft-3 is the same as 1.0 so files should be able to be submitted to Cromwell as 1.0
      # "draft-3" {
        # language-factory = "languages.wdl.draft3.WdlDraft3LanguageFactory"
        # config {
        #   strict-validation: true
        #   enabled: true
        # }
      # }
      "1.0" {
        # 1.0 is just a rename of draft-3, so yes, they really do use the same factory:
        # language-factory = "languages.wdl.draft3.WdlDraft3LanguageFactory"
        # config {
        #   strict-validation: true
        #   enabled: true
        # }
      }
    }
  }
  CWL {
    versions {
      "v1.0" {
        # language-factory = "languages.cwl.CwlV1_0LanguageFactory"
        # config {
        #   strict-validation: false
        #   enabled: true
        # }
      }
    }
  }
}

# Here is where you can define the backend providers that Cromwell understands.
# The default is a local provider.
# To add additional backend providers, you should copy paste additional backends
# of interest that you can find in the cromwell.example.backends folder
# folder at https://www.github.com/broadinstitute/cromwell
# Other backend providers include SGE, SLURM, Docker, udocker, Singularity. etc.
# Don't forget you will need to customize them for your particular use case.
backend {
  # Override the default backend.
  default = "SLURM"

  # The list of providers.
  providers {
    # Copy paste the contents of a backend provider in this section
    # Examples in cromwell.example.backends include:
    # LocalExample: What you should use if you want to define a new backend provider
    # AWS: Amazon Web Services
    # BCS: Alibaba Cloud Batch Compute
    # TES: protocol defined by GA4GH
    # TESK: the same, with kubernetes support
    # Google Pipelines, v2 (PAPIv2)
    # Docker
    # Singularity: a container safe for HPC
    # Singularity+Slurm: and an example on Slurm
    # udocker: another rootless container solution
    # udocker+slurm: also exemplified on slurm
    # HtCondor: workload manager at UW-Madison
    # LSF: the Platform Load Sharing Facility backend
    # SGE: Sun Grid Engine
    # SLURM: workload manager
    # Spark: cluster

    # Note that these other backend examples will need tweaking and configuration.
    # Please open an issue https://www.github.com/broadinstitute/cromwell if you have any questions

    # The local provider is included by default. This is an example.
    # Define a new backend provider.

    SLURM {
      # The actor that runs the backend. In this case, it's the Shared File System (SFS) ConfigBackend.
      actor-factory = "cromwell.backend.impl.sfs.config.ConfigBackendLifecycleActorFactory"
      config {
        runtime-attributes = """
        String time = "01:00:00"
        Int cpus = 1
        Int memory_mb_per_core = 4775
        Int memory_mb = 1
        String Account = "rrg-bourqueg-ad"
	Int maxRetries = 3
        """

        submit = """
        if [ ${memory_mb} -eq 1 ] ; then  MEM=${memory_mb_per_core}  ; else MEM=$((${memory_mb}/${cpus})) ;fi  && \
	sbatch -J ${job_name} -D ${cwd} -o ${out} -e ${err} -t ${time}  \
        -c ${cpus} -N 1  -A ${Account}  \
        --mem-per-cpu $MEM \
        --wrap "/bin/bash ${script}"
        """
        kill = "scancel ${job_id}"
        check-alive = "squeue -j ${job_id}"
        job-id-regex = "Submitted batch job (\\d+).*"
    }
  }





    LocalExample {
      # The actor that runs the backend. In this case, it's the Shared File System (SFS) ConfigBackend.
      actor-factory = "cromwell.backend.impl.sfs.config.ConfigBackendLifecycleActorFactory"

      # The backend custom configuration.
      config {

        # Optional limits on the number of concurrent jobs
        concurrent-job-limit = 5

        # If true submits scripts to the bash background using "&". Only usefull for dispatchers that do NOT submit
        # the job and then immediately return a scheduled job id.
        run-in-background = true

        # `temporary-directory` creates the temporary directory for commands.
        #
        # If this value is not set explicitly, the default value creates a unique temporary directory, equivalent to:
        # temporary-directory = "$(mktemp -d \"$PWD\"/tmp.XXXXXX)"
        #
        # The expression is run from the execution directory for the script. The expression must create the directory
        # if it does not exist, and then return the full path to the directory.
        #
        # To create and return a non-random temporary directory, use something like:
        temporary-directory = "$(echo $SLURM_TMPDIR)"

        # `script-epilogue` configures a shell command to run after the execution of every command block.
        #
        # If this value is not set explicitly, the default value is `sync`, equivalent to:
        # script-epilogue = "sync"
        #
        # To turn off the default `sync` behavior set this value to an empty string:
        # script-epilogue = ""

	# `glob-link-command` specifies command used to link glob outputs, by default using hard-links.
	# If filesystem doesn't allow hard-links (e.g., beeGFS), change to soft-links as follows:
	# glob-link-command = "ln -sL GLOB_PATTERN GLOB_DIRECTORY"

	# The list of possible runtime custom attributes.
        runtime-attributes = """
        String? docker
        String? docker_user
        """

        # Submit string when there is no "docker" runtime attribute.
        submit = "/usr/bin/env bash ${script}"

        # Submit string when there is a "docker" runtime attribute.
        submit-docker = """
        docker run \
          --rm -i \
          ${"--user " + docker_user} \
          --entrypoint ${job_shell} \
          -v ${cwd}:${docker_cwd} \
          ${docker} ${docker_script}
        """

        # Root directory where Cromwell writes job results.  This directory must be
        # visible and writeable by the Cromwell process as well as the jobs that Cromwell
        # launches.
        root = "cromwell-executions"

        # Root directory where Cromwell writes job results in the container. This value
        # can be used to specify where the execution folder is mounted in the container.
        # it is used for the construction of the docker_cwd string in the submit-docker
        # value above.
        dockerRoot = "/cromwell-executions"

        # File system configuration.
        filesystems {

          # For SFS backends, the "local" configuration specifies how files are handled.
          local {

            # Try to hard link (ln), then soft-link (ln -s), and if both fail, then copy the files.
            localization: [
              "hard-link", "soft-link", "copy"
            ]
            # An experimental localization strategy called "cached-copy" is also available for SFS backends.
            # This will copy a file to a cache and then hard-link from the cache. It will copy the file to the cache again
            # when the maximum number of hardlinks for a file is reached. The maximum number of hardlinks can be set with:
            # max-hardlinks: 950

            # Call caching strategies
            caching {
              # When copying a cached result, what type of file duplication should occur. Attempted in the order listed below:
              duplication-strategy: [
                "hard-link", "soft-link", "copy"
              ]

              # Possible values: file, path, path+modtime
              # "file" will compute an md5 hash of the file content.
              # "path" will compute an md5 hash of the file path. This strategy will only be effective if the duplication-strategy (above) is set to "soft-link",
              # in order to allow for the original file path to be hashed.
              # "path+modtime" will compute an md5 hash of the file path and the last modified time. The same conditions as for "path" apply here.
              # Default: file
              hashing-strategy: "file"

              # When true, will check if a sibling file with the same name and the .md5 extension exists, and if it does, use the content of this file as a hash.
              # If false or the md5 does not exist, will proceed with the above-defined hashing strategy.
              check-sibling-md5: false
            }
          }
        }

        # The defaults for runtime attributes if not provided.
        default-runtime-attributes {
          failOnStderr: false
          continueOnReturnCode: 0
        }
      }
    }
  }
}

services {
  MetadataService {

    # This class is the "default" database backed implementation:
    # class = "cromwell.services.metadata.impl.MetadataServiceActor"
    # config {
    #   # For the standard MetadataService implementation, cromwell.services.metadata.impl.MetadataServiceActor:
    #   #   Set this value to "Inf" to turn off metadata summary refresh.  The default value is currently "1 second".
    #   metadata-summary-refresh-interval = "Inf"
    #
    #   #   Set this value to the maximum number of metadata rows to be considered per summarization cycle.
    #   metadata-summary-refresh-limit = 5000
    #
    #   #   For higher scale environments, e.g. many workflows and/or jobs, DB write performance for metadata events
    #   #   can improved by writing to the database in batches. Increasing this value can dramatically improve overall
    #   #   performance but will both lead to a higher memory usage as well as increase the risk that metadata events
    #   #   might not have been persisted in the event of a Cromwell crash.
    #   #
    #   #   For normal usage the default value of 200 should be fine but for larger/production environments we recommend a
    #   #   value of at least 500. There'll be no one size fits all number here so we recommend benchmarking performance and
    #   #   tuning the value to match your environment.
    #   db-batch-size = 200
    #
    #   #   Periodically the stored metadata events will be forcibly written to the DB regardless of if the batch size
    #   #   has been reached. This is to prevent situations where events wind up never being written to an incomplete batch
    #   #   with no new events being generated. The default value is currently 5 seconds
    #   db-flush-rate = 5 seconds
    # }

    # Alternative 1: Pub sub implementation:
    # class = "cromwell.services.metadata.impl.MetadataServiceActor"
    # config {
    #   # For the Google PubSub MetadataService implementation: cromwell.services.metadata.impl.pubsub.PubSubMetadataServiceActor:
    #   #   Google project
    #   project = "my-project"
    #   #   The auth *must* be a service-account auth with JSON auth.
    #   auth = "service-account"
    #   #   The PubSub topic to write to. Will be created if it doesn't already exist. Defaults to "cromwell-metadata"
    #   topic = "cromwell-metadata"
    #   #   An optional PubSub subscription name. If supplied and if it doesn't already exist, it will be created and
    #   #   subscribed to the topic
    #   #   subscription = "optional-subscription"
    #   #   An application name to set on your PubSub interaction.
    #   appName = "cromwell"
    # }

    # Alternative 2: Hybrid (classic + carbonite) implementation:
    # class = "cromwell.services.metadata.hybridcarbonite.HybridMetadataServiceActor"
    # config {
    #   # This section can also contain the same set of options as would be present in the 'config' section of the
    #   # default (cromwell.services.metadata.impl.MetadataServiceActor) config
    #
    #   # The carbonite section contains carbonite-specific options
    #   carbonite-metadata-service {
    #
    #     # Which bucket to use for storing or retrieving metadata JSON
    #     bucket = "carbonite-test-bucket"
    #
    #     # Limit on bytes we attempt to read from the bucket when retrieving a JSON
    #     # This refers to the uncompressed size of a downloaded file. Sizes shown in the GCS interface are highly compressed.
    #     bucket-read-limit-bytes = 150000000
    #
    #     # A filesytem able to access the specified bucket:
    #     filesystems {
    #       gcs {
    #         # A reference to the auth to use for storing and retrieving metadata:
    #         auth = "application-default"
    #       }
    #     }
    #
    #     # Metadata freezing configuration. All of these entries are optional and default to the values shown below.
    #     # In particular, the default value of `Inf` for `initial-interval` turns off metadata freezing, so an explict
    #     # non-`Inf` value would need to be chosen for that parameter to turn metadata freezing on.
    #     metadata-freezing {
    #       # How often Cromwell should check for metadata ready for freezing. Set the `initial-interval` value to "Inf"
    #       # (or leave the default unchanged) to turn off metadata freezing. Both interval parameters must be durations,
    #       # if initial is finite then max must be greater than initial, and multiplier must be a number greater than 1.
    #       initial-interval = Inf
    #       max-interval = 5 minutes
    #       multiplier = 1.1
    #
    #       # Only freeze workflows whose summary entry IDs are greater than or equal to `minimum-summary-entry-id`.
    #       minimum-summary-entry-id = 0
    #
    #       # Whether to output log messages whenever freezing activity is started or completed (this can be problematically
    #       # noisy in some CI circumstances).
    #       debug-logging = true
    #     }
    #
    #     # Metadata deletion configuration.
    #     metadata-deletion {
    #
    #       # How long to wait after system startup before the first metadata deletion action.
    #       # This is potentially useful to avoid overwhelming a newly-starting Cromwell service with lots of deletion activity.
    #       initial-delay = 5 minutes
    #
    #       # How often Cromwell should check for metadata ready for deletion. Set this value to "Inf" to turn off metadata deletion.
    #       # The default value is currently "Inf".
    #       interval = Inf
    #
    #       # Upper limit for the number of workflows which Cromwell will process during a single scheduled metadata deletion event.
    #       # The default value is currently "200".
    #       batch-size = 200
    #
    #       # Minimum time between a workflow completion and deletion of its metadata from the database.
    #       # Note: Metadata is only eligible for deletion if it has already been carbonited.
    #       # The default value is currently "24 hours".
    #       delay-after-workflow-completion = 24 hours
    #     }
    #   }
    # }
  }

  Instrumentation {
    # StatsD - Send metrics to a StatsD server over UDP
    # class = "cromwell.services.instrumentation.impl.statsd.StatsDInstrumentationServiceActor"
    # config {
    #   hostname = "localhost"
    #   port = 8125
    #   prefix = "" # can be used to prefix all metrics with an api key for example
    #   flush-rate = 1 second # rate at which aggregated metrics will be sent to statsd
    # }

    # Stackdriver - Send metrics to Google's monitoring API
    # class = "cromwell.services.instrumentation.impl.stackdriver.StackdriverInstrumentationServiceActor"
    # config {
    #   # auth scheme can be `application_default` or `service_account`
    #   auth = "service-account"
    #   google-project = "my-project"
    #   # rate at which aggregated metrics will be sent to Stackdriver API, must be 1 minute or more.
    #   flush-rate = 1 minute
    #   # below 3 keys are attached as labels to each metric. `cromwell-perf-test-case` is specifically meant for perf env.
    #   cromwell-instance-identifier = "cromwell-101"
    #   cromwell-instance-role = "role"
    #   cromwell-perf-test-case = "perf-test-1"
    # }
  }
  HealthMonitor {
    config {

      #####
      # Choose what to monitor:
      #####

      # If you want to check the availability of the PAPI or PAPIv2 services, list them here.
      # If provided, all values here *MUST* be valid PAPI or PAPIv2 backend names in the Backends stanza.
      # NB: requires 'google-auth-name' to be set
      # check-papi-backends: [ PAPIv2 ]

      # If you want to check connection to GCS (NB: requires 'google-auth-name' and 'gcs-bucket-to-check' to be set):
      # check-gcs: true

      # If you want to check database connectivity:
      # check-engine-database: true

      # If you want to check dockerhub availability:
      # check-dockerhub: true

      # If you want to check that Carboniter has read access to objects in its GCS bucket
      # check-carboniter-gcs-access: true

      #####
      # General health monitor configuration:
      #####

      # How long to wait between status check sweeps
      # check-refresh-time = 5 minutes

      # For any given status check, how long to wait before assuming failure
      # check-timeout = 1 minute

      # For any given status datum, the maximum time a value will be kept before reverting back to "Unknown"
      # status-ttl = 15 minutes

      # For any given status check, how many times to retry a failure before setting status to failed. Note this
      # is the number of retries before declaring failure, not the total number of tries which is 1 more than
      # the number of retries.
      # check-failure-retry-count = 3

      # For any given status check, how long to wait between failure retries.
      # check-failure-retry-interval = 30 seconds

      #####
      # GCS- and PAPI-specific configuration options:
      #####

      # The name of an authentication scheme to use for e.g. pinging PAPI and GCS. This should be either an application
      # default or service account auth, otherwise things won't work as there'll not be a refresh token where you need
      # them.
      # google-auth-name = application-default

      # A *bucket* in GCS to periodically stat to check for connectivity. This must be accessible by the auth mode
      # specified by google-auth-name
      # NB: This is a *bucket name*, not a URL and not an *object*. With 'some-bucket-name', Cromwell would ping gs://some-bucket-name
      # gcs-bucket-to-check = some-bucket-name

      # A path to the GCS canary-object which you would like to use in `Carboniter GCS access check`
      # The path should not include bucket name, since bucket name will be taken from the Carboniter configuration
      # gcs-object-to-check-carboniter-access = "healthcheck.txt"
    }
  }
  LoadController {
    config {
      # The load controller service will periodically look at the status of various metrics its collecting and make an
      # assessment of the system's load. If necessary an alert will be sent to the rest of the system.
      # This option sets how frequently this should happen
      # To disable load control, set this to "Inf"
      # control-frequency = 5 seconds
    }
  }
}

database {
  # mysql example
  #driver = "slick.driver.MySQLDriver$"

  # see all possible parameters and default values here:
  # http://slick.lightbend.com/doc/3.2.0/api/index.html#slick.jdbc.JdbcBackend$DatabaseFactoryDef@forConfig(String,Config,Driver):Database
  #db {
  #  driver = "com.mysql.jdbc.Driver"
  #  url = "jdbc:mysql://host/cromwell?rewriteBatchedStatements=true"
  #  user = "user"
  #  password = "pass"
  #  connectionTimeout = 5000
  #}



 profile = "slick.jdbc.HsqldbProfile$"
  db {
    driver = "org.hsqldb.jdbcDriver"
    url = """
    jdbc:hsqldb:file:__DATA_BASE_ROOT__cromwell-executions/cromwell-db/cromwell-db;
    shutdown=false;
    hsqldb.default_table_type=cached;hsqldb.tx=mvcc;
    hsqldb.result_max_memory_rows=10000;
    hsqldb.large_data=true;
    hsqldb.applog=1;
    hsqldb.lob_compressed=true;
    hsqldb.script_format=3
    """
    connectionTimeout = 120000
    numThreads = 1
   }



  # For batch inserts the number of inserts to send to the DB at a time
  # insert-batch-size = 2000

  migration {
    # For databases with a very large number of symbols, selecting all the rows at once can generate a variety of
    # problems. In order to avoid any issue, the selection is paginated. This value sets how many rows should be
    # retrieved and processed at a time, before asking for the next chunk.
    #read-batch-size = 100000

    # Because a symbol row can contain any arbitrary wdl value, the amount of metadata rows to insert from a single
    # symbol row can vary from 1 to several thousands (or more). To keep the size of the insert batch from growing out
    # of control we monitor its size and execute/commit when it reaches or exceeds writeBatchSize.
    #write-batch-size = 100000
  }

  # To customize the metadata database connection, create a block under `database` with the metadata database settings.
  #
  # For example, the default database stores all data in memory. This commented out block would store `metadata` in an
  # hsqldb file, without modifying the internal engine database connection.
  #
  # The value `${uniqueSchema}` is always replaced with a unqiue UUID on each cromwell startup.
  #
  # This feature should be considered experimental and likely to change in the future.

  #metadata {
  #  profile = "slick.jdbc.HsqldbProfile$"
  #  db {
  #    driver = "org.hsqldb.jdbcDriver"
  #    url = "jdbc:hsqldb:file:metadata-${uniqueSchema};shutdown=false;hsqldb.tx=mvcc"
  #    connectionTimeout = 3000
  #  }
  #}

  # Postgresql example
  #database {
  #  profile = "slick.jdbc.PostgresProfile$"
  #  db {
  #    driver = "org.postgresql.Driver"
  #    url = "jdbc:postgresql://localhost:5432/cromwell"
  #    user = ""
  #    password = ""
  #    port = 5432
  #    connectionTimeout = 5000
  #  }
  #}
}
