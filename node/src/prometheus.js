'use strict'
import fetch from 'node-fetch';

const prometheusUrl = process.env.PROMETHEUS_URL || 'http://prometheus-service:9090'
const aliasTag = encodeURIComponent(process.env.TOTAL_WH_ALIAS_TAG || "Washing Machine")

const config = { timeout: 2000 }
const basicAuth = process.env.BASIC_AUTH
if (basicAuth) { config.headers = { 'Authorization': 'Basic ' + basicAuth } }

const whCounterQuery = 'scalar(max(total_wh{alias="' + aliasTag + '"}))'
const fetchWhCounter = async time => {
    const url = `${prometheusUrl}/api/v1/query?query=${whCounterQuery}&time=${time.toISOString()}`
    try {
        const response = await fetch(url, config)
        const json = await response.json()
        console.log(json.data)
        if (json.status == 'success' && json.data.resultType == 'scalar') {
            return parseInt(json.data.result[1])
        }
        return null
    } catch (exception) {
        console.log("Couldn't execute WhCounter query against prometheus: " + exception)
        return null
    }
}

export default {
    fetchWhCounter
};
