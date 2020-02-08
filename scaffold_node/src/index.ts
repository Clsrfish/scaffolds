import Koa from "koa";

class Main {
    msg: string;
    constructor(p: string) {
        this.msg = p
    }

    run() {
        console.log(this.msg)
        let koa = new Koa()
        koa.use(async ctx => {
            console.log("request accpted")
        })
        koa.listen(3000)
    }
}
let app = new Main("hello")
app.run()