<template>
  <div>
    <v-card
      color="background"
      flat
      :class="$vuetify.theme.isDark ? 'rounded-0 pa-3' : 'rounded-0 pa-3 bgm'"
    >
      <v-card-title
        class="text-sm-h5 text-xs-h6 font-weight-bold secondary--text"
        >Add FTM + DICE to the Liquidity Pool to earn DICE
      </v-card-title>
      <v-card-text>
        <div>Powered by the fastest blockchain Fantom</div>
      </v-card-text>
    </v-card>
    <div class="items">
      <div class="items__item">
        <div v-html="liquidityAlert"></div>
        <v-card class="rounded-xl card" color="background" outlined>
          <v-app-bar flat color="rgba(0, 0, 0, 0)">
            <v-toolbar-title class="title white--text pl-0"
              >Add Liquidity</v-toolbar-title
            >
            <v-spacer></v-spacer>
            <v-btn icon @click="dialog = true">
              <v-icon>mdi-cog</v-icon>
            </v-btn>
            <v-btn icon @click="dialog2 = true">
              <v-icon>mdi-history</v-icon>
            </v-btn>
          </v-app-bar>

          <v-divider></v-divider>
          <v-list color="transparent" class="my-6">
            <v-list-item style="width: 100%" class="my-2">
              <div
                class="px-3 py-2 rounded-lg"
                style="width: 100%; background-color: #dddddd20"
              >
                <div>FTM</div>
                <div style="display: flex; justify-content: space-between">
                  <span class="form-control"
                    ><input
                      type="number"
                      class="form-control"
                      Placeholder="0.0"
                      v-model="bnbAmount"
                      @keyup="keyUpEvent('bnb')"
                  /></span>
                  <span style="display: flex"
                    ><v-img
                      width="25"
                      class="mr-2"
                      :src="require('../assets/fantom-ftm.png')"
                    />
                    FTM</span
                  >
                </div>
              </div>
            </v-list-item>

            <v-list-item
              style="width: 100%; display: flex; justify-content: center"
              class="my-2"
            >
              <v-btn icon >
                <v-icon>mdi-plus</v-icon>
              </v-btn>
            </v-list-item>
            <v-list-item style="width: 100%" class="my-2">
              <div
                class="px-3 py-2 rounded-lg"
                style="width: 100%; background-color: #dddddd20"
              >
                <div>DICE</div>
                <div style="display: flex; justify-content: space-between">
                  <span class="form-control"
                    ><input
                      type="number"
                      class="form-control"
                      Placeholder="0.0"
                      v-model="diceAmount"
                      @keyup="keyUpEvent('dice')"
                  /></span>
                  <span style="display: flex"
                    ><v-img
                      width="25"
                      class="mr-2"
                      :src="require('../assets/DICE-COIN.png')"
                    />
                    DICE</span
                  >
                </div>
              </div>
            </v-list-item>
            <v-list-item
              style="width: 100%; display: flex; justify-content: center"
              class="my-2"
            >
              <div
                style="
                  display: flex;
                  justify-content: space-between;
                  width: 100%;
                "
              >
                <span>Slippage Tolerance</span>
                <span>1%</span>
              </div>
            </v-list-item>
            <v-list-item
              style="width: 100%; display: flex; justify-content: center"
              class="my-2"
            >
              <v-btn
                rounded
                color="#01659c"
                elevation="0"
                block
                @click="unlockWallet()"
                >{{poolStatus}}
              </v-btn>
            </v-list-item>
          </v-list>
          <v-expansion-panels flat class="my-5">
                        <v-expansion-panel class="transparent">
                            <v-expansion-panel-header>Details</v-expansion-panel-header>
                            <v-expansion-panel-content>
                                <div class="d-flex justify-space-between">
                                    <div>Deposit:</div>
                                    <div>DICE-FTM LP</div>
                                </div>
                                <div class="d-flex justify-space-between">
                                    <div>Total Liquidity:</div>
                                    <div>$000,000,000</div>
                                </div>
                                <div class="d-flex justify-space-between">
                                    <div>LP price:</div>
                                    <div>~0</div>
                                </div>
                            </v-expansion-panel-content>
                        </v-expansion-panel>
                    </v-expansion-panels>
        </v-card>
      </div>
    </div>
    <v-dialog v-model="dialog" width="500">
      <v-card class="rounded-xl card" color="background" flat>
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-toolbar-title class="title white--text pl-0">
            Alert
          </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialog = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-app-bar>
        <v-card-text>
          {{ alertMsg }}
        </v-card-text>
      </v-card>
    </v-dialog>
    <v-dialog v-model="dialog2" width="500">
      <v-card class="rounded-xl card" color="background" flat>
        <v-app-bar flat color="rgba(0, 0, 0, 0)">
          <v-toolbar-title class="title white--text pl-0">
            History
          </v-toolbar-title>
          <v-spacer></v-spacer>
          <v-btn icon @click="dialog2 = false">
            <v-icon>mdi-close</v-icon>
          </v-btn>
        </v-app-bar>
        <v-card-text>
          Transaction history
        </v-card-text>
      </v-card>
    </v-dialog>
  </div>
</template>

<script>
import { mapGetters, mapMutations } from "vuex"

export default {
  name: "AddLiquidity",

  data() {
    return {
      from: { id: 1, name: "user1" },
      to: { id: 1, name: "user2" },
      dialog: false,
      dialog2: false,
      alertMsg: "",
      bnbAmount: 0.0,
      diceAmount: 0.0,
      bnbReserve: -1,
      diceReserve: -1,
      liquidityAlert: ""
    };
  },

  computed: {
    ...mapGetters({
      appState: "appState",
      tokenBalance: "tokenBalance",
      bnbBalance: "bnbBalance",
      poolStatus: 'poolStatus',
      viewStatus: 'viewStatus'
    }),
  },

  mounted() {
    if (this.appState.diceContract)
      this.appState.diceContract.methods
        .getReserves()
        .call()
        .then((res) => {
          this.bnbReserve = Number(res.amountA) / Math.pow(10, 18);
          this.diceReserve = Number(res.amountB) / Math.pow(10, 8);
        });
  },

  methods: {
    ...mapMutations(["callTokenBalance", "getBalance"]),

    getSharePercent() {
      this.appState.diceContract.methods
        .getLiquidity(this.appState.walletAddress)
        .call()
        .then((myPool) => {
          this.appState.diceContract.methods
            .getTotalLiquidity()
            .call()
            .then((totalPool) => {
              var myPer = (myPool * 100) / totalPool;
              var str = "Your liquidity share pool " + myPer.toFixed(2) + "%";
              this.alertMessage(str);
            });
        });
    },

    liquidity() {
      this.liquidityAlert = ""
      if (this.appState.walletAddress === "CONNECT") {
        //this.alertMessage("please connect wallet");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Please connect your wallet</div>";
        return;
      }

      this.bnbAmount = Number(this.bnbAmount);
      this.diceAmount = Number(this.diceAmount);
      this.bnbAmount = this.bnbAmount.toFixed(4);
      this.diceAmount = this.diceAmount.toFixed(0);

      if (this.bnbAmount <= 0 || this.diceAmount <= 0) {
        //this.alertMessagert("amount can not be same or under 0");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Thinkg about selecting some FTM and DICE?</div>";
        return;
      }

      if (this.bnbReserve < 0 || this.diceReserve < 0) {
        //this.alertMessage("reserve received not yet from net");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Reserve has not received yet</div>";
        return;
      }

      if (this.bnbAmount > this.bnbBalance) {
        //this.alertMessage("insufficient fmt for liquidity pool");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient FTM for liquidity pool</div>";
        return;
      }

      if (this.diceAmount > this.tokenBalance) {
        //this.alertMessage("insufficient token for liquidity pool");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient DICE for liquidity pool</div>";
      }
      //decimal : 8,  1wei : 1000000000000000000
      if (this.bnbReserve === 0 && this.diceReserve === 0) {
        //this.alertMessage("adding first liquidity......");
        this.appState.diceContract.methods
          .addLiquidityETH(
            this.diceAmount * 100000000,
            1,
            1,
            this.appState.walletAddress
          )
          .send({
            from: this.appState.walletAddress,
            value: Math.pow(10, 18) * this.bnbAmount,
          })
          .then(() => {
            this.getBalance();
            this.appState.diceContract.methods
              .getReserves()
              .call()
              .then((res) => {
                this.bnbReserve = Number(res.amountA) / Math.pow(10, 18);
                this.diceReserve = Number(res.amountB) / Math.pow(10, 8);
              });

            this.getSharePercent();
          });
      } else {
        /*if (this.bnbAmount < Math.pow(10, -4))
          this.alertMessage("fmt amount to exchange is too low ");

        if (
          this.diceAmount <
          (Math.pow(10, -4) * this.diceReserve) / this.bnbReserve
        )
          this.alertMessage("diceAmount to exchange is too low");*/

        this.appState.diceContract.methods
          .addLiquidityETH(
            this.diceAmount * 100000000,
            1,
            1,
            this.appState.walletAddress
          )
          .send({
            from: this.appState.walletAddress,
            value: Math.pow(10, 18) * this.bnbAmount,
          })
          .then(() => {
            this.getBalance();
            this.appState.diceContract.methods
              .getReserves()
              .call()
              .then((res) => {
                this.bnbReserve = Number(res.amountA) / Math.pow(10, 18);
                this.diceReserve = Number(res.amountB) / Math.pow(10, 8);
              });

            this.getSharePercent();
          });
      }
    },

    keyUpEvent(token) {
      if (this.appState.walletAddress === "CONNECT") {
        this.bnbAmount = 0;
        this.diceAmount = 0;
        //this.alertMessage("connect wallet!!!!");
        //this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>please connect to wallet</div>";
        return;
      }

      if (this.bnbReserve < 0 || this.diceReserve < 0) {
        //this.alertMessage("reserve received not yet from net");
        this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Loading...</div>";
        return;
      }

      if (this.bnbReserve === 0 || this.diceReserve === 0) return;

      if (token === "bnb") {
        if (this.bnbAmount > this.bnbBalance) {
          this.bnbAmount = 0;
          this.diceAmount = 0;
          //this.alertMessage("insufficient fmt balance");
          this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient FTM balance</div>";
          return
        } else {
          this.diceAmount =
            (this.diceReserve / this.bnbReserve) * this.bnbAmount;
          if (this.diceAmount > this.tokenBalance) {
            this.diceAmount = this.tokenBalance;
          }
        }
      } else if (token === "dice") {
        if (this.diceAmount > this.tokenBalance) {
          this.bnbAmount = 0;
          this.diceAmount = 0;
          //this.alertMessage("insufficient token balance");
          this.liquidityAlert = "<div style='border: 2px solid white; text-align: center; border-radius: 30px; margin: auto; width: 60%; padding: 10px; margin-bottom: 20px'>Insufficient DICE balance</div>";
          return
        } else {
          this.bnbAmount =
            (this.bnbReserve / this.diceReserve) * this.diceAmount;
          if (this.bnbAmount > this.bnbBalance) {
            this.bnbAmount = this.bnbBalance;
          }
        }
      }
      this.liquidityAlert = ""
    },
    alertMessage(msg) {
      this.alertMsg = msg;
      this.dialog = true;
    },
    async unlockWallet() {
      if (typeof window.ethereum === "undefined") {
        return;
      }

      if (this.appState.walletStatus !== "CONNECT") {
        this.liquidity()
        return
      }

      window.ethereum.request({
        method: "eth_requestAccounts",
      });
    },
  },
};
</script>

<style scoped>
.card {
  position: relative;
  height: 100%;
}

.bg {
  position: absolute;
  top: 70px;
  right: 30px;
  opacity: 0.4;
}

.items {
  display: flex;
  justify-content: center;
}

.items__item {
  max-width: 400px;
  min-width: 50%;
  width: 100%;
  margin: 20px;
}

@media (max-width: 900px) {
  .card {
    position: relative;
    height: 100%;
  }

  .items {
    display: flex;
    justify-content: center;
    flex-direction: column;
  }

  .items__item {
    max-width: 90%;
  }
}

.form-control {
  color: white;
  width: 100%;
}
</style>