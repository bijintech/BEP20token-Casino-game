import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
  state: {
    web3: null,
    diceContract: null,
    walletAddress: 'Connect Wallet',
    bscConnect: false,
    tokenBalance: 0.0,
    bnbBalance: 0.0,
    alertMsg: '',
    alert: false
  },

  getters: {
    appState: state => state,
    tokenBalance: state => state.tokenBalance,
    bnbBalance: state => state.bnbBalance,
    alertMsg: state => state.alertMsg,
    alert: state => state.alert
  },

  mutations: {
    chageState(state, appState) {
      if (appState.web3)
        state.web3 = appState.web3

      if (appState.walletAddress)
      state.walletAddress = appState.walletAddress

      if (appState.bscConnect)
      state.bscConnect = appState.bscConnect

      if (appState.diceContract)
      state.diceContract = appState.diceContract

      if (appState.alertMsg !== "" && appState.alertMsg) {
        state.alertMsg = appState.alertMsg
        state.alert = true
      } else if (appState.alert === false) {
        state.alert = false
      }
    },

    getBalance(state) {
      if (state.walletAddress !== "Connect Wallet") {
        state.diceContract.methods.balanceOf(state.walletAddress).call(
        ).then((res) => {
          state.tokenBalance = res / 100000000 //decimal is 8
        }).catch(() => {
          state.tokenBalance = 0
        })

        state.web3.eth.getBalance(state.walletAddress).then((res) => {
          state.bnbBalance = res / 1000000000000000000 //decimal is 18
        }).catch(() => {
          state.bnbBalance = 0
        })
      } else {
        state.tokenBalance = 0
        state.bnbBalance = 0
      }
    }
  }
});