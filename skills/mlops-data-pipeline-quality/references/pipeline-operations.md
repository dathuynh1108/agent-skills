# Pipeline Operations Checklist

- Can the job resume from the last successful checkpoint?
- Is the job safe to rerun for the same interval?
- Are retries bounded and observable?
- Can bad data be quarantined?
- Are downstream consumers protected from partial outputs?
- Are lineage and version metadata written with outputs?
- Is there a rollback or mitigation for bad model/data promotion?
